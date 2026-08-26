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


