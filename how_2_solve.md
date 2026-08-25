select * from damage_logs
where username = "xCalibur"
order by damage_timestamp desc;

- who could do 34 dmg?

SELECT
c.class_name,
w.weapon_name,
(w.damage + c.damage_min) AS total_min_damage,
(w.damage + c.damage_max) AS total_max_damage
FROM classes AS c
CROSS JOIN weapons AS w
WHERE 34 BETWEEN
(w.damage+ c.damage_min)
AND (w.damage + c.damage_max)
ORDER BY c.class_name, w.weapon_name;

returns 7 rows

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