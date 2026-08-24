DROP TABLE IF EXISTS trades;

CREATE TABLE trades (
  id INTEGER PRIMARY KEY,
  item TEXT NOT NULL,
  item_rarity TEXT NOT NULL CHECK (item_rarity IN ('common', 'uncommon', 'rare', 'legendary')),
  item_effect TEXT CHECK (item_effect IN ('burning', 'poisoned', 'electrified', 'rusted')),
  trade_timestamp TEXT NOT NULL,
  buyer TEXT NOT NULL,
  seller TEXT NOT NULL
);

INSERT INTO trades (id, item, item_rarity, item_effect, trade_timestamp, buyer, seller) VALUES
  (1, 'Iron Dagger', 'common', 'rusted', '18:51:09', 'MoonPriest', 'GromByte'),
  (2, 'Steel Mace', 'uncommon', 'electrified', '18:53:42', 'ShieldTotem', 'RuneTank'),
  (3, 'Worn Sword', 'common', 'burning', '18:56:27', 'xCalibur', 'ArthasMain'),
  (4, 'Oak Buckler', 'common', NULL, '18:58:11', 'EluneKid', 'VoidCook'),
  (5, 'Hunter Axe', 'uncommon', 'rusted', '19:00:04', 'GromByte', 'MoonPriest'),
  (6, 'Silver Ring', 'rare', NULL, '19:01:35', 'RuneTank', 'ShieldTotem'),
  (7, 'Runed Cloak', 'rare', NULL, '19:03:18', 'ArthasMain', 'EluneKid'),
  (8, 'dagger', 'legendary', 'poisoned', '19:09:05', 'easily_gullible123', 'VoidCook');
