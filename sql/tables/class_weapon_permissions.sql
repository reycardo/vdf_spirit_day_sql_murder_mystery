DROP TABLE IF EXISTS class_weapon_permissions;

CREATE TABLE class_weapon_permissions (
  id INTEGER PRIMARY KEY,
  class_name TEXT NOT NULL,
  weapon_name TEXT NOT NULL,
  UNIQUE (class_name, weapon_name),
  FOREIGN KEY (class_name) REFERENCES classes(class_name),
  FOREIGN KEY (weapon_name) REFERENCES weapons(weapon_name)
);

INSERT INTO class_weapon_permissions (id, class_name, weapon_name) VALUES
  (1, 'mage', 'staff'),
  (2, 'mage', 'dagger'),
  (3, 'rogue', 'dagger'),
  (4, 'rogue', 'sword'),
  (5, 'warrior', 'sword'),
  (6, 'warrior', 'axe'),
  (7, 'warrior', 'dagger'),
  (8, 'bard', 'sword'),
  (9, 'bard', 'axe'),
  (10, 'bard', 'dagger');