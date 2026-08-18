DROP TABLE IF EXISTS beastiary;

CREATE TABLE beastiary (
  id INTEGER PRIMARY KEY,
  monster_name TEXT NOT NULL UNIQUE,
  weapon_equiped TEXT NOT NULL,
  place TEXT NOT NULL
);

INSERT INTO beastiary (id, monster_name, weapon_equiped, place) VALUES
  (1, 'Ashfang Whelp', 'Burning Claws', 'Ember Market'),
  (2, 'Boglurker', 'Rusted Trident', 'Moonlit Docks'),
  (3, 'Stormcoil Serpent', 'Electrified Fangs', 'Shattered Arena'),
  (4, 'Nightmaw', 'Poisoned Talons', 'Whisper Grove');