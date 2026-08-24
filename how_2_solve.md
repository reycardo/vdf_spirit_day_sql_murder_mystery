select * from damage_logs
where username = "xCalibur"
order by damage_timestamp desc;

id	username	damage_timestamp	damage_taken
14	xCalibur	19:07:41	34
13	xCalibur	19:07:24	12
11	xCalibur	19:06:55	16
9	xCalibur	19:06:19	13
7	xCalibur	19:05:54	17
5	xCalibur	19:05:16	11
3	xCalibur	19:04:41	15

who could do 34 dmg?

SELECT
c.class_name,
w.weapon_name,
we.weapon_effect,
(w.damage + we.damage_increment + c.damage_min) AS total_min_damage,
(w.damage + we.damage_increment + c.damage_max) AS total_max_damage
FROM classes AS c
CROSS JOIN weapons AS w
CROSS JOIN weapon_effects AS we
WHERE 34 BETWEEN
(w.damage + we.damage_increment + c.damage_min)
AND (w.damage + we.damage_increment + c.damage_max)
ORDER BY c.class_name, w.weapon_name, we.weapon_effect;