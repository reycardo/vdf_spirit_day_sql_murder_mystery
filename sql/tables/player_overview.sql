DROP TABLE IF EXISTS player_overview;

CREATE TABLE player_overview (
  username TEXT PRIMARY KEY,
  class TEXT NOT NULL,
  current_equiped_weapon TEXT NOT NULL
);

INSERT INTO player_overview (username, class, current_equiped_weapon) VALUES
  ('ArthasMain', 'Warrior', 'Worn Sword'),
  ('MoonPriest', 'Cleric', 'Silver Ring'),
  ('xCalibur', 'Rogue', 'Iron Dagger'),
  ('RuneTank', 'Paladin', 'Steel Mace'),
  ('EluneKid', 'Hunter', 'Hunter Axe');