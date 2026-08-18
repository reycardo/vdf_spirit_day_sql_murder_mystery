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


TODO: find something to thin out what class the killer was using
TODO: find something to thin out what weapon the killer was using


- will have to find what weapon was used at time of death
- initial image will say it was a burning weapon (possible weapons that would kill would be a non burning weapon and the correct burning weapon)
- searching for trades with dagger	    legendary	    burning will show too many distinct weapons exist
- will have to find what class was the killer, via the damage the weapon did
- warrior (+5,+5) dmg
- mage (-10,-5) dmg was a mage with a dagger does 40 dmg + burning +1
- rogue (double dmg) first hit then + 0
- bard (+0 dmg)
- will know the killer is a mage, now needs to filter for mages that were in X zone 
- Z X Y zones exist, some have different monsters, will have to know what monsters xCalibur was fighting before dying to know what zone he was.
- He was fighting Nightmaw in Whisper Grove, and damage_logs shows he was hit with burning Talons - then we know that he died in Whisper Grove
- We then check on tolls where place is Whisper Grove and find a mage that went there
- Then we need to check from there, what mages also traded the legendary dagger to the easily gullible that currently has the dagger

- have a table with tolls (username, entered, place)

- killer traded weapon to easily_Gullible123 after time of death
- 4 monsters available, each monster deals damage differently, they have to check 
- damage logs reveal that 

- have an image for how damage works = class + base weapon damage + effect
- have an image for how travelling works = takes 1h to be out of combat to move from one location to the next