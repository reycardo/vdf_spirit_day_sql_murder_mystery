DROP TABLE IF EXISTS tolls;

CREATE TABLE tolls (
  username TEXT NOT NULL,
  timezone TEXT NOT NULL,
  check_in TIMESTAMP NOT NULL,
  check_out TIMESTAMP NOT NULL,
  place TEXT NOT NULL,
  PRIMARY KEY (username, check_in),
  FOREIGN KEY (username) REFERENCES player_overview(username)
);

INSERT INTO tolls (username, timezone, check_in, check_out, place) VALUES
  ('ArthasMain', 'UTC-5', '2026-06-12 18:40:00', '2026-06-12 19:20:00', 'Zone X - Ember Market'),
  ('MoonPriest', 'UTC+1', '2026-06-12 18:45:00', '2026-06-12 19:05:00', 'Zone Y - Moonlit Docks'),
  ('xCalibur', 'UTC+0', '2026-06-12 18:50:00', '2026-06-12 19:08:00', 'Zone Z - Shattered Arena'),
  ('RuneTank', 'UTC-3', '2026-06-12 18:48:00', '2026-06-12 19:18:00', 'Zone X - Iron Gate'),
  ('EluneKid', 'UTC+9', '2026-06-12 18:52:00', '2026-06-12 19:15:00', 'Zone Y - Whisper Grove');