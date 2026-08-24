DROP TABLE IF EXISTS zone_presence;

CREATE TABLE zone_presence (
  id INTEGER PRIMARY KEY,
  username TEXT NOT NULL,
  place TEXT NOT NULL REFERENCES places(place_name),
  entered_at TEXT NOT NULL,
  left_at TEXT
);

INSERT INTO zone_presence (id, username, place, entered_at, left_at) VALUES
  (1, 'xCalibur', 'Whisper Grove', '18:30:00', NULL),
  (2, 'VoidCook', 'Whisper Grove', '18:55:00', '19:20:00'),
  (3, 'ShadowMend', 'Whisper Grove', '18:40:00', '19:12:00'),
  (4, 'RuneTank', 'Whisper Grove', '19:00:00', '19:25:00'),
  (5, 'GromByte', 'Whisper Grove', '17:50:00', '18:45:00'),
  (6, 'MoonPriest', 'Whisper Grove', '19:20:00', '19:55:00'),
  (7, 'EluneKid', 'Ember Market', '18:30:00', '19:30:00'),
  (8, 'ArthasMain', 'Shattered Arena', '18:00:00', '19:40:00'),
  (9, 'GrittyGnome', 'Moonlit Docks', '18:10:00', '19:50:00'),
  (10, 'easily_gullible123', 'Ember Market', '19:00:00', '19:30:00'),
  (11, 'PixelPaladin', 'Whisper Grove', '17:00:00', '18:20:00'),
  (12, 'TinyTitan', 'Whisper Grove', '19:30:00', '20:00:00'),
  (13, 'NightOwlKit', 'Whisper Grove', '18:45:00', '19:15:00'),
  (14, 'SilentArrow', 'Whisper Grove', '18:50:00', '19:30:00'),
  (15, 'MysticRogue7', 'Whisper Grove', '19:05:00', '19:20:00'),
  (16, 'WanderingSage', 'Whisper Grove', '18:20:00', NULL),
  (17, 'CrimsonFang', 'Whisper Grove', '18:58:00', '19:18:00'),
  (18, 'FrostByte99', 'Whisper Grove', '18:35:00', '19:10:00');
