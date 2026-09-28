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
  (2, 'Boglurker', 23, 24, 1, 'Moonlit Docks'),
  (3, 'Stormcoil Serpent', 23, 24, 0, 'Shattered Arena'),
  (4, 'Nightmaw', 11, 19, 1, 'Whisper Grove'),
  (5, 'Cinder Rat', 3, 4, 0, 'Ember Market'),
  (6, 'Dockshade Eel', 20, 22, 1, 'Moonlit Docks'),
  (7, 'Arena Howler', 20, 22, 0, 'Shattered Arena'),
  (8, 'Gloom Spriggan', 1, 4, 1, 'Whisper Grove'),
  (9, 'Sootback Brute', 7, 10, 0, 'Ember Market'),
  (10, 'Tidehook Lurker', 25, 26, 1, 'Moonlit Docks'),
  (11, 'Glassfang Raptor', 25, 26, 0, 'Shattered Arena'),
  (12, 'Murk Stag', 5, 10, 1, 'Whisper Grove'),
  (13, 'Blazebloom Imp', 5, 6, 0, 'Ember Market'),
  (14, 'Harbor Wraith', 27, 28, 1, 'Moonlit Docks'),
  (15, 'Pitcoil Hound', 11, 19, 0, 'Shattered Arena'),
  (16, 'Thornveil Bear', 27, 28, 0, 'Whisper Grove');
