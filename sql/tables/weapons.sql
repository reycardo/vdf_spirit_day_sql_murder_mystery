DROP TABLE IF EXISTS weapons;

CREATE TABLE weapons (
  id INTEGER PRIMARY KEY,
  weapon_name TEXT NOT NULL UNIQUE CHECK (weapon_name IN ('sword', 'axe', 'dagger', 'staff')),
  damage INTEGER NOT NULL
);

INSERT INTO weapons (id, weapon_name, damage) VALUES
  (1, 'sword', 20),
  (2, 'axe', 25),
  (3, 'dagger', 30),
  (4, 'staff', 35);
