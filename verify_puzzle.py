"""Canon/data guard suite for the murder-mystery database.

Builds sql/database.sql into an in-memory SQLite DB (resolving @include
directives like app.py does) and asserts every invariant the puzzle relies on.
Exit code is non-zero if any check fails.
"""

import re
import sqlite3
import sys

DB_FILE = "sql/database.sql"
VICTIM = "xCalibur"
DEATH_TIME = "19:07"
KILLER_BLOW = ("xCalibur", "19:07", 34)
GROVE = "Whisper Grove"
FORBIDDEN_START, FORBIDDEN_END = "18:00", "18:30"
VICTIM_WINDOW_START, VICTIM_WINDOW_END = "19:04", "19:06"
EXPECTED_SUSPECTS = {
    "CrimsonFang", "FrostByte99", "GromByte", "MoonPriest", "PixelPaladin",
    "QuietStorm", "RuneTank", "ShadowMend", "ShieldTotem", "SilentArrow",
    "TinyTitan", "VelvetHex", "WanderingSage",
}

failures: list[str] = []


def check(label: str, ok: bool, detail: str = "") -> None:
    print(f"[{'PASS' if ok else 'FAIL'}] {label}" + (f" -- {detail}" if detail else ""))
    if not ok:
        failures.append(label)


def load_db() -> sqlite3.Connection:
    with open(DB_FILE, encoding="utf-8") as f:
        sql = f.read()
    includes: dict[str, str] = {}
    for path in re.findall(r"--\s*@include\s+(\S+)", sql):
        with open("sql/" + path, encoding="utf-8") as f:
            includes[path] = f.read()
    full = re.sub(
        r"--\s*@include\s+(\S+)", lambda m: includes[m.group(1)], sql
    )
    con = sqlite3.connect(":memory:")
    con.executescript(full)
    return con


con = load_db()
check("1 schema executes cleanly after include resolution", True)

monsters = con.execute(
    "SELECT monster_name, damage_min, damage_max, nocturnal, place FROM beastiary"
).fetchall()
sunset = dict(con.execute("SELECT place_name, sunset FROM places"))
rows = con.execute(
    "SELECT id, username, combat_id, damage_timestamp, damage_taken FROM damage_logs"
).fetchall()


def candidates(dmg: int, ts: str) -> list[str]:
    return [
        m[0]
        for m in monsters
        if m[1] <= dmg <= m[2]
        and ((ts[:5] >= sunset[m[4]]) == bool(m[3]))
    ]


bad_attr = [
    (rid, user, ts, dmg, cands)
    for rid, user, _, ts, dmg in rows
    for cands in [candidates(dmg, ts)]
    if len(cands) != 1
]
attr_bad = [x for x in bad_attr if (x[1], x[2], x[3]) != KILLER_BLOW]
check(
    "2 every row attributes to exactly one active monster",
    not attr_bad,
    f"violations: {attr_bad}" if attr_bad else "",
)

killer_rows = [
    (r[1], r[3], r[4], candidates(r[4], r[3]))
    for r in rows
    if r[4] == KILLER_BLOW[2]
]
check(
    "3 killer blow unique and unattributable",
    len(killer_rows) == 1
    and killer_rows[0][:3] == KILLER_BLOW
    and killer_rows[0][3] == [],
)

forbidden = [r[:2] for r in rows if FORBIDDEN_START <= r[3] < FORBIDDEN_END]
check("4 no rows in collision window 18:00-18:30", not forbidden, str(forbidden))

# Grove-attributable hits per player (unique-candidate attribution only).
grove_hits: dict[str, list[str]] = {}
for _, user, _, ts, dmg in rows:
    cands = candidates(dmg, ts)
    if len(cands) == 1:
        owner = next(m for m in monsters if m[0] == cands[0])
        if owner[4] == GROVE:
            grove_hits.setdefault(user, []).append(ts)

grove_sunset = sunset[GROVE]
tripwire = []
for user, hits in grove_hits.items():
    before = any(h < grove_sunset for h in hits)
    after = any(h > DEATH_TIME for h in hits)
    during = any(grove_sunset <= h <= DEATH_TIME for h in hits)
    if before and after and not during:
        tripwire.append(user)
check(
    "5 nightfall-coverage tripwire (no stayers missing the hunt window)",
    not tripwire,
    f"violations: {tripwire}" if tripwire else "",
)

pool = {
    r[0]
    for r in con.execute(
        "SELECT DISTINCT username FROM damage_logs "
        "WHERE damage_taken BETWEEN ? AND ? "
        "AND damage_timestamp BETWEEN ? AND ?",
        (11, 19, grove_sunset, DEATH_TIME),
    )
}
expected_pool = EXPECTED_SUSPECTS | {VICTIM}
check("6 suspect pool matches expected", pool == expected_pool,
      f"missing: {sorted(expected_pool - pool)}, extra: {sorted(pool - expected_pool)}")

victim_rows = [
    r for r in rows
    if r[1] == VICTIM
    for _ in [0]
]
nm_band = next((m[1], m[2]) for m in monsters if m[0] == "Nightmaw")
victim_nm = [
    r for r in victim_rows
    if nm_band[0] <= r[4] <= nm_band[1]
    and VICTIM_WINDOW_START <= r[3] <= VICTIM_WINDOW_END
]
timeline_ok = (
    len(victim_nm) == 5
    and len(victim_rows) == 6
    and sum(1 for r in victim_rows if r[4] == KILLER_BLOW[2]) == 1
)
check("7 victim timeline: five beast hits then the killing blow", timeline_ok)

print()
if failures:
    print(f"FAILED: {len(failures)} check(s): {failures}")
    sys.exit(1)
print("ALL CHECKS PASSED")
