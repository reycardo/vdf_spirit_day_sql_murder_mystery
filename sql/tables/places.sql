DROP TABLE IF EXISTS places;

CREATE TABLE places (
  id INTEGER PRIMARY KEY,
  place_name TEXT NOT NULL UNIQUE,
  sunset TEXT NOT NULL,
  sunrise TEXT NOT NULL
);

INSERT INTO places (id, place_name, sunset, sunrise) VALUES
  (1, 'Ember Market', '19:20:00', '05:48:00'),
  (2, 'Moonlit Docks', '20:00:00', '05:42:00'),
  (3, 'Shattered Arena', '18:50:00', '05:55:00'),
  (4, 'Whisper Grove', '18:00:00', '06:10:00');