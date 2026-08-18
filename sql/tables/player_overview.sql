DROP TABLE IF EXISTS player_overview;

CREATE TABLE player_overview (
  id INTEGER PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  class TEXT NOT NULL,
  current_equiped_weapon TEXT NOT NULL
);

INSERT INTO player_overview (id, username, class, current_equiped_weapon) VALUES
  (1, 'ArthasMain', 'Warrior', 'Worn Sword'),
  (2, 'MoonPriest', 'Cleric', 'Silver Ring'),
  (3, 'xCalibur', 'Rogue', 'Iron Dagger'),
  (4, 'RuneTank', 'Paladin', 'Steel Mace'),
  (5, 'EluneKid', 'Hunter', 'Hunter Axe');