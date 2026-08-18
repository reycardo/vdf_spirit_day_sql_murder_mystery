DROP TABLE IF EXISTS beastiary;

CREATE TABLE beastiary (
  id INTEGER PRIMARY KEY,
  monster_name TEXT NOT NULL UNIQUE,
  damage_min INTEGER NOT NULL,
  damage_max INTEGER NOT NULL,
  nocturnal BOOLEAN NOT NULL CHECK (nocturnal IN (0, 1)),
  place TEXT NOT NULL
);

INSERT INTO beastiary (id, monster_name, damage_min, damage_max, nocturnal, place) VALUES
  (1, 'Ashfang Whelp', 1, 2, 0, 'Ember Market'),
  (2, 'Boglurker', 4, 6, 1, 'Moonlit Docks'),
  (3, 'Stormcoil Serpent', 10, 11, 0, 'Shattered Arena'),
  (4, 'Nightmaw', 5, 15, 1, 'Whisper Grove');