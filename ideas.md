add id to everything no gaps

- kid died in game
- check damage_logs by username

select * from damage_logs
where username = "xCalibur"
order by damage_timestamp desc;

- will show that xCalibur died from a 34 damage hit
- will also show that after 19h he got hits that range from 11-17
- will also show that after 18h he got hits that range from 5-8

SELECT DISTINCT
  monster_name,
  damage_min,
  damage_max,
  place
FROM beastiary
WHERE damage_min <= 11
  AND damage_max >= 17  
ORDER BY monster_name;

- tell user that nocturnal monsters only appear at night

SELECT DISTINCT
b.monster_name,
b.damage_min,
b.damage_max,
b.place,
b.nocturnal,
p.sunset,
p.sunrise,
CASE
WHEN b.nocturnal = 1 AND '19:00:00' >= p.sunset THEN 1
WHEN b.nocturnal = 1 AND '19:00:00' < p.sunset THEN 0
WHEN b.nocturnal = 0 AND '19:00:00' < p.sunset THEN 1
WHEN b.nocturnal = 0 AND '19:00:00' >= p.sunset THEN 0
END AS spawned_at_19
FROM beastiary AS b
JOIN places AS p
ON b.place = p.place_name
WHERE b.damage_min <= 11
AND b.damage_max >= 17
ORDER BY b.monster_name;

- user finds that only place that could have monster that hit for that damage at 19h is Whisper Grove


SELECT * FROM zone_presence 
WHERE place = 'Whisper Grove' 
AND entered_at <= '19:07:41' 
AND (left_at IS NULL OR left_at >= '19:07:41');

- user finds who was at Whisper Grove at time of death


- now they will have to query for what can hit for 34 damage

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

- Cross check with equipable weapons per class:

SELECT
  c.class_name,
  w.weapon_name,
  we.weapon_effect,
  (w.damage + we.damage_increment + c.damage_min) AS total_min_damage,
  (w.damage + we.damage_increment + c.damage_max) AS total_max_damage
FROM classes AS c
JOIN class_weapon_permissions AS cwp
  ON cwp.class_name = c.class_name
JOIN weapons AS w
  ON w.weapon_name = cwp.weapon_name
CROSS JOIN weapon_effects AS we
WHERE 34 BETWEEN
      (w.damage + we.damage_increment + c.damage_min)
  AND (w.damage + we.damage_increment + c.damage_max)
ORDER BY c.class_name, w.weapon_name, we.weapon_effect;

TODO: find something to thin out what class the killer was using


The weapon was a poisoned dagger

possible suspects: 



- knowing that the player was a mage 

SELECT * FROM player_overview b
join possible_suspects a
on a.username = b.username
where class = "mage"

- killer traded weapon to easily_Gullible123 after time of death

- have an image for how damage works = class + base weapon damage + effect
- have an image for how travelling works = takes 1h to be out of combat to move from one location to the next

- added zone_presence (username, place, entered_at, left_at) so players can filter who was actually
  in Whisper Grove around 19:07:41 (time of death); narrows suspects to VoidCook, ShadowMend, RuneTank
  (everyone else was elsewhere or had already left/not yet arrived)


