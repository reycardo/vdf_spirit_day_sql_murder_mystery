DROP TABLE IF EXISTS places;

CREATE TABLE places (
  id INTEGER PRIMARY KEY,
  place_name TEXT NOT NULL UNIQUE,
  sunset TEXT NOT NULL,
  sunrise TEXT NOT NULL
);

INSERT INTO places (id, place_name, sunset, sunrise) VALUES
  (1, 'Ember Market', '18:00', '06:00'),
  (2, 'Moonlit Docks', '20:00', '05:00'),
  (3, 'Shattered Arena', '18:30', '06:00'),
  (4, 'Whisper Grove', '18:00', '06:00');