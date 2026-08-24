DROP TABLE IF EXISTS weapons;

CREATE TABLE weapons (
  weapon_name TEXT PRIMARY KEY CHECK (weapon_name IN ('sword', 'axe', 'dagger', 'staff')),
  damage INTEGER NOT NULL
);

INSERT INTO weapons (weapon_name, damage) VALUES
  ('sword', 20),
  ('axe', 25),
  ('dagger', 30),
  ('staff', 35);
