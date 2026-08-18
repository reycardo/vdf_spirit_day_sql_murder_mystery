DROP TABLE IF EXISTS tolls;

CREATE TABLE tolls (
  id INTEGER PRIMARY KEY,
  username TEXT NOT NULL,
  day DATE NOT NULL,
  place TEXT NOT NULL,
  UNIQUE (username, day, place),
  FOREIGN KEY (username) REFERENCES player_overview(username)
);

INSERT INTO tolls (id, username, day, place) VALUES
  (1, 'ArthasMain', '2026-06-12', 'Ember Market'),
  (2, 'MoonPriest', '2026-06-12', 'Moonlit Docks'),
  (3, 'xCalibur', '2026-06-12', 'Shattered Arena'),
  (4, 'xCalibur', '2026-06-12', 'Whisper Grove'),
  (5, 'RuneTank', '2026-06-12', 'Iron Gate'),
  (6, 'EluneKid', '2026-06-12', 'Whisper Grove');