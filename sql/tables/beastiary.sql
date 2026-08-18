DROP TABLE IF EXISTS beastiary;

CREATE TABLE beastiary (
  monster_name TEXT PRIMARY KEY,
  weapon_equiped TEXT NOT NULL,
  place TEXT NOT NULL
);

INSERT INTO beastiary (monster_name, weapon_equiped, place) VALUES
  ('Ashfang Whelp', 'Burning Claws', 'Zone X - Ember Market'),
  ('Boglurker', 'Rusted Trident', 'Zone Y - Moonlit Docks'),
  ('Stormcoil Serpent', 'Electrified Fangs', 'Zone Z - Shattered Arena'),
  ('Nightmaw', 'Poisoned Talons', 'Zone Y - Whisper Grove');