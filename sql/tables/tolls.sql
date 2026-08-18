DROP TABLE IF EXISTS tolls;

CREATE TABLE tolls (
  username TEXT NOT NULL,
  day DATE NOT NULL,
  place TEXT NOT NULL,
  PRIMARY KEY (username, day),
  FOREIGN KEY (username) REFERENCES player_overview(username)
);

INSERT INTO tolls (username, day, place) VALUES
  ('ArthasMain', '2026-06-12', 'Ember Market'),
  ('MoonPriest', '2026-06-12', 'Moonlit Docks'),
  ('xCalibur', '2026-06-12', 'Shattered Arena'),
  ('RuneTank', '2026-06-12', 'Iron Gate'),
  ('EluneKid', '2026-06-12', 'Whisper Grove');