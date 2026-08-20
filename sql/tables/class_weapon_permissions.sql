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
  (1, 'mage', 'mace'),
  (2, 'rogue', 'dagger'),
  (3, 'warrior', 'sword'),
  (4, 'warrior', 'axe'),
  (5, 'warrior', 'dagger'),
  (6, 'warrior', 'mace'),
  (7, 'bard', 'sword'),
  (8, 'bard', 'axe'),
  (9, 'bard', 'dagger'),
  (10, 'bard', 'mace');