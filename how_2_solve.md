# How to Solve — Author Walkthrough

The complete solution path, Q1 through Q7. Every query below was verified against the
current `sql/database.sql`; outcomes and deductions are what a player sees when they run
each step. Canon rules players may legally rely on are called out in blockquotes.

---

## Game canon (what players are told)

> **Entry auto-attack** — entering any location immediately draws an attack from a beast
> that roams there. The hit always lands in `damage_logs`.

> **Nightfall aggression** — when night falls on a location (its `sunset`), its nocturnal
> beasts start hunting *everyone still present*. Nobody who stays past dark escapes a hit.

> **Nocturnal & sunset** — beasts with `nocturnal = 1` are active from local `sunset`
> until `sunrise`; beasts with `nocturnal = 0` are active before sunset instead. Whether a
> monster *could* have struck depends on the clock of the place it lives in.

> **Combat math** — a player's hit lands anywhere between
> `weapon damage + class damage_min` and `weapon damage + class damage_max`, and classes
> may only wield weapons listed in `class_weapon_permissions` (even if the weapon changed
> hands afterwards).

---

## Q1 — Find the moment of death

```sql
SELECT *
FROM damage_logs
WHERE username = 'xCalibur'
ORDER BY combat_id DESC, damage_timestamp DESC;
```

**Outcome:** top row is a single-hit combat: **34 damage at 19:07**. Below it: five hits
of 11–17 from one shared `combat_id` between 19:04 and 19:06.

**Deduction:** one attacker was grinding him down, then an anomalous blow finished him.
Time of death: **19:07**.

---

## Q2 — Rule out a beast for the killing blow

```sql
SELECT * FROM beastiary WHERE 34 BETWEEN damage_min AND damage_max;
-- empty result
```

**Outcome:** no monster reaches 34 (the hardest beast caps at 28).

**Deduction:** the killing blow came from a **player weapon**, not a beast. To find
*where* he died, use the beast hits he survived longest.

---

## Q3 — Attribute the pre-death burst by range

```sql
SELECT DISTINCT monster_name, nocturnal, place
FROM beastiary
WHERE damage_min <= 11 AND damage_max >= 17;
```

**Outcome:** exactly two candidates — **Nightmaw** (nocturnal, Whisper Grove) and
**Pitcoil Hound** (diurnal, Shattered Arena).

**Deduction:** ranges alone cannot pick between them: two monsters, two different places.
Something else has to break the tie.

---

## Q4 — Use nocturnal + sunset to pin the place

```sql
SELECT b.monster_name, p.place_name,
  CASE WHEN b.nocturnal = 1 AND '19:07' >= p.sunset THEN 'ACTIVE'
       WHEN b.nocturnal = 0 AND '19:07' <  p.sunset THEN 'ACTIVE'
       ELSE 'asleep' END AS status
FROM beastiary b JOIN places p ON p.place_name = b.place
WHERE b.monster_name IN ('Nightmaw', 'Pitcoil Hound');
```

**Outcome:** Nightmaw ACTIVE, Pitcoil Hound asleep (Shattered Arena's sunset is 18:30,
and 19:07 is past it).

**Deduction:** xCalibur was fighting a Nightmaw — so he died in **Whisper Grove**.

---

## Q5 — Prove who was in Whisper Grove (build the suspects table)

> Relies on **nightfall aggression**: anyone present when night fell was guaranteed a
> night-band hit, and per **entry auto-attack** nobody can be in a place without having
> been hit there. So a hit from any Grove nocturnal beast between Grove sunset (18:00)
> and death (19:07) proves presence at the murder — and no such hit can exist for anyone
> who wasn't.

All three nocturnal Grove beasts share the night window, and their bands (1–19) cover
every hit they can deal: Gloom Spriggan 1–4, Murk Stag 5–10, Nightmaw 11–19. Ember
Market's day beasts — the only ones with overlapping damage bands — sleep from 18:00,
exactly when the Grove wakes, so nothing muddies the attribution.

```sql
CREATE TABLE suspects (
  username TEXT PRIMARY KEY
);

INSERT INTO suspects (username)
SELECT DISTINCT username
FROM damage_logs
WHERE damage_taken BETWEEN 1 AND 19              -- any of the Grove's night beasts
  AND damage_timestamp BETWEEN '18:00' AND '19:07';  -- after sunset, before/at death
```

**Outcome:** 14 rows — CrimsonFang, FrostByte99, GromByte, MoonPriest, PixelPaladin,
QuietStorm, RuneTank, ShadowMend, ShieldTotem, SilentArrow, TinyTitan, VelvetHex,
WanderingSage, plus the victim xCalibur himself.

**Deduction:** these are the only players provably inside Whisper Grove at the time of
death. Day visitors (Bear-hit before 18:00) and late arrivals (first Grove hit after
19:07) are correctly excluded.

---

## Q6 — Who among them can deal 34 damage?

```sql
SELECT po.username, po.class, w.weapon_name,
       w.damage + c.damage_min AS min_hit,
       w.damage + c.damage_max AS max_hit
FROM suspects AS s
JOIN player_overview po           ON po.username = s.username
JOIN class_weapon_permissions cwp ON cwp.class_name = po.class
JOIN weapons w                    ON w.weapon_name = cwp.weapon_name
JOIN classes c                    ON c.class_name = po.class
WHERE 34 BETWEEN w.damage + c.damage_min AND w.damage + c.damage_max
ORDER BY po.username;
```

**Outcome:** only **rogue + dagger (30–50)** straddles 34 — survivors:
**ShieldTotem** and **SilentArrow** (plus the victim xCalibur, a rogue himself — exclude
him). Everyone else misses: bard+sword tops out at 29, mage+staff starts at 35,
warrior+axe at 35.

**Deduction:** the killer is one of the two rogues. Note the join runs through
`class_weapon_permissions`, not the currently equipped weapon — trading the murder weapon
away afterwards changes nothing.

---

## Q7 — The tiebreaker: who fled?

> Relies on **entry auto-attack**: whoever left Whisper Grove after the murder took a
> fresh-zone beast hit somewhere else. The innocent suspect has no such row.

Narrow the table to the finalists:

```sql
DELETE FROM suspects WHERE username NOT IN ('ShieldTotem', 'SilentArrow');
```

Then look for flight:

```sql
SELECT DISTINCT s.username
FROM suspects AS s
JOIN damage_logs AS dl ON dl.username = s.username
WHERE dl.damage_taken BETWEEN 20 AND 28        -- any non-Grove beast band
  AND dl.damage_timestamp > '19:07';           -- ...after the murder
```

**Outcome:** exactly one row-set match — **ShieldTotem**, hit for 21 by a Dockshade Eel
at 20:12 (Moonlit Docks wakes at 20:00; a fresh-zone entry attack). SilentArrow's log
shows Grove hits continuing to 19:34 — he stayed all night.

**Deduction:** ShieldTotem left the crime scene right after the kill. You can't outrun
the beasts — the flight convicts him.

---

## Solution

**ShieldTotem** — rogue, dagger, present in Whisper Grove at 19:07, capable of exactly 34
damage, and gone from the Grove within the hour.
