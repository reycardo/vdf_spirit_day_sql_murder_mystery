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
  (1, 'warrior', 'dagger'),
  (2, 'warrior', 'axe'),
  (3, 'mage', 'staff'),
  (4, 'rogue', 'dagger'),
  (5, 'bard', 'sword'),
  (6, 'monk', 'sword');