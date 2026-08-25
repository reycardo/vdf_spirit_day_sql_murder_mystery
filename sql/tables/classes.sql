DROP TABLE IF EXISTS classes;

CREATE TABLE classes (
  class_name TEXT PRIMARY KEY,
  damage_min INTEGER NOT NULL,
  damage_max INTEGER NOT NULL
);

INSERT INTO classes (class_name, damage_min, damage_max) VALUES
  ('warrior', 10, 14),
  ('mage', 0, 3),
  ('rogue', 0, 20),
  ('bard', 4, 9),
  ('monk', 6, 11);