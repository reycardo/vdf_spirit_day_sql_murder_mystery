# How to Solve — Author Walkthrough

The complete solution path, Q1 through Q7. Every query below was verified against the
current `sql/database.sql`; outcomes and deductions are what a player sees when they run
each step. Canon rules players may legally rely on are called out in blockquotes.

---

## Game canon (what players are told)

> **Entry auto-attack** — entering a location draws an attack from any beast still awake
> there, and the hit lands in `damage_logs`. A beast that is asleep won't notice you, so a
> night-time crossing into a sleeping-beast zone (Ember Market, Shattered Arena) leaves no
> trace. That asymmetry is what makes the witness statement in the intro necessary.

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

## Q7 — Where did the killer go?

> The intro's witness provides the key: the killer's trail was stained with black marsh
> muck, "the same filth that coats the lair of the Boglurker." Decode it:
>
> ```sql
> SELECT place FROM beastiary WHERE monster_name = 'Boglurker';
> ```
>
> → **Moonlit Docks**. Then **entry auto-attack + night frenzy** do the rest: anyone at the
> Docks after it wakes at 20:00 is guaranteed a logged 20–28 band hit (nobody present can
> avoid it), while a night-time escape to Ember Market or the Arena leaves **no trace**
> (their beasts are asleep). So the Docks are the only *provable* destination — which is
> exactly where the witness puts the killer.
>
> Note the witness detail also works if read literally — "attacked by a Boglurker" rather
> than "fled past its lair": ShieldTotem's Docks strike is a Boglurker hit (23 damage),
> so both interpretations point at the same place and the same name.

The two-zone intersection — provably in the Grove at death *and* in the Docks after:

```sql
SELECT DISTINCT s.username
FROM suspects AS s
JOIN damage_logs AS dl ON dl.username = s.username
WHERE dl.damage_taken BETWEEN 20 AND 28        -- Docks signature
  AND dl.damage_timestamp > '19:07';           -- ...after the murder
```

**Outcome:** a crowd, not a name — **12 players**: CrimsonFang, FrostByte99, GromByte,
MoonPriest, PixelPaladin, QuietStorm, RuneTank, ShadowMend, TinyTitan, VelvetHex,
WanderingSage **and ShieldTotem**. Plenty of innocent Grove survivors also went to the
Docks that night, so the destination alone proves nothing.

**Deduction:** this is why **Q6 is mandatory**. Intersect the crowd against who can deal
34 — only the rogue can — and the non-rogue visitors (bards, warriors, mages) fall away,
leaving **ShieldTotem**. Run it the other way (Q6 first to finalists, then Q7's Docks
filter) and you get the same single name: neither step can be skipped.

**Deduction (final):** ShieldTotem was in the Grove at 19:07, can land exactly 34, and is
the only finalist whose log shows a Moonlit Docks strike after the kill — a Boglurker hit
at 20:12, matching the witness's marsh-muck trail. He fled the crime scene. You can't
outrun the beasts; the flight convicts him.

---

## Solution

**ShieldTotem** — rogue, dagger, provably in Whisper Grove at 19:07, capable of exactly 34
damage, and the only Grove suspect whose log places him in Moonlit Docks after the murder.
