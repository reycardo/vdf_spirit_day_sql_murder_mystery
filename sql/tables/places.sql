DROP TABLE IF EXISTS places;

CREATE TABLE places (
  place_name TEXT PRIMARY KEY,
  sunset TEXT NOT NULL,
  sunrise TEXT NOT NULL
);

INSERT INTO places (place_name, sunset, sunrise) VALUES
  ('Ember Market', '19:20:00', '05:48:00'),
  ('Moonlit Docks', '19:05:00', '05:42:00'),
  ('Shattered Arena', '18:50:00', '05:55:00'),
  ('Whisper Grove', '18:00:00', '06:10:00');