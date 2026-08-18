- kid died in game
- check logs of death by username
- (time, username dmged, damage taken)
- will show that xCalibur died from a 34 damage hit
- now they will have to query for what can hit for 34 damage
- they will know that he was on Whisper Grove + arena from tolls
- from the hits that he also took they will know that he was on Whisper Grove before dying

username	damage_timestamp	damage_taken
xCalibur	2026-06-12 19:07:41	34

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
- have an image for weapon rarity (common, uncommon, rare, legendary)
- have an image for weapon types (sword, axe, dagger, mace)
- have an image for weapon effects (burning, poisoned, electrified, rusted)
- killer traded weapon to easily_Gullible123 after time of death
- 4 monsters available, each monster deals damage differently, they have to check 
- damage logs reveal that 