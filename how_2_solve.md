Q1 — Find the death moment

SELECT * 
FROM damage_logs
where username = 'xCalibur'
ORDER BY combat_id desc, damage_timestamp desc;

Top row: 34 damage at 19:07 (its own combat_id — one single hit). Below it: a burst of 11–17 hits from the same combat_id in the minutes before. 

Deduction: something small-to-mid was grinding him down, then one anomalous blow finished him.

Q2 — Rule out a monster for the killing blow

SELECT * FROM beastiary WHERE 34 BETWEEN damage_min AND damage_max;
-- empty

No beast hits for 34 → the last hit came from a player weapon. But to place him, use the monster hits:

Q3 — Attribute the pre-death burst by range

SELECT DISTINCT monster_name, nocturnal, place
FROM beastiary
WHERE damage_min <= 11 AND damage_max >= 17;

Exactly two candidates: Nightmaw (nocturnal) and Thornveil Bear (diurnal). Both rows say place = Whisper Grove — the place is already pinned, no matter which of the two it was.

Q4 — Use nocturnal + sunset to pick the culprit (the step you wanted players forced into)

SELECT b.monster_name, p.place_name,
  CASE WHEN b.nocturnal = 1 AND '19:07' >= p.sunset THEN 'ACTIVE'
       WHEN b.nocturnal = 0 AND '19:07' <  p.sunset THEN 'ACTIVE'
       ELSE 'asleep' END AS status
FROM beastiary b JOIN places p ON p.place_name = b.place
WHERE b.monster_name IN ('Nightmaw', 'Thornveil Bear');

- cross check with classes that can equip those weapons

SELECT
  c.class_name,
  w.weapon_name,
  (w.damage + c.damage_min) AS total_min_damage,
  (w.damage + c.damage_max) AS total_max_damage
FROM classes AS c
JOIN class_weapon_permissions AS cwp
  ON cwp.class_name = c.class_name
JOIN weapons AS w
  ON w.weapon_name = cwp.weapon_name
WHERE 34 BETWEEN
      (w.damage + c.damage_min)
  AND (w.damage + c.damage_max)
ORDER BY c.class_name, w.weapon_name;

returns:

rogue	dagger	30	50


trying where the killer was 