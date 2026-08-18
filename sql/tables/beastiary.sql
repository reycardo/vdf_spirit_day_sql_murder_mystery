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
  (4, 'Nightmaw', 5, 19, 1, 'Whisper Grove'),
  (5, 'Cinder Rat', 0, 3, 0, 'Ember Market'),
  (6, 'Dockshade Eel', 2, 8, 1, 'Moonlit Docks'),
  (7, 'Arena Howler', 7, 13, 0, 'Shattered Arena'),
  (8, 'Gloom Spriggan', 1, 9, 1, 'Whisper Grove'),
  (9, 'Sootback Brute', 6, 14, 0, 'Ember Market'),
  (10, 'Tidehook Lurker', 3, 12, 1, 'Moonlit Docks'),
  (11, 'Glassfang Raptor', 9, 16, 0, 'Shattered Arena'),
  (12, 'Murk Stag', 4, 10, 1, 'Whisper Grove'),
  (13, 'Blazebloom Imp', 0, 5, 0, 'Ember Market'),
  (14, 'Harbor Wraith', 8, 17, 1, 'Moonlit Docks'),
  (15, 'Pitcoil Hound', 11, 20, 0, 'Shattered Arena'),
  (16, 'Thornveil Bear', 5, 18, 0, 'Whisper Grove');