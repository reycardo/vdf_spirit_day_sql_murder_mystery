DROP TABLE IF EXISTS tolls;

CREATE TABLE tolls (
  id INTEGER PRIMARY KEY,
  username TEXT NOT NULL,
  entered TEXT NOT NULL,
  place TEXT NOT NULL,
  UNIQUE (username, entered, place),
  FOREIGN KEY (username) REFERENCES player_overview(username)
);

INSERT INTO tolls (id, username, entered, place) VALUES
  (1, 'ArthasMain', '18:40:00', 'Ember Market'),
  (2, 'MoonPriest', '18:45:00', 'Moonlit Docks'),
  (3, 'xCalibur', '18:00:00', 'Shattered Arena'),
  (4, 'xCalibur', '19:02:00', 'Whisper Grove'),
  (5, 'RuneTank', '18:48:00', 'Iron Gate'),
  (6, 'EluneKid', '18:52:00', 'Whisper Grove');