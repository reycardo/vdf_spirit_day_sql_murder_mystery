DROP TABLE IF EXISTS classes;

CREATE TABLE classes (
  id INTEGER PRIMARY KEY,
  class_name TEXT NOT NULL UNIQUE,
  damage_min INTEGER NOT NULL,
  damage_max INTEGER NOT NULL
);

INSERT INTO classes (id, class_name, damage_min, damage_max) VALUES
  (1, 'warrior', 10, 14),
  (2, 'mage', 0, 3),
  (3, 'rogue', 0, 20),
  (4, 'bard', 4, 9),
  (5, 'monk', 6, 11);