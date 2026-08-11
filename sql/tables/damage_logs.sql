DROP TABLE IF EXISTS damage_logs;

CREATE TABLE damage_logs (
  id INTEGER PRIMARY KEY,
  username TEXT NOT NULL,
  damage_timestamp TEXT NOT NULL,
  weapon_name TEXT NOT NULL CHECK (weapon_name IN ('axe', 'dagger', 'sword', 'mace')),
  weapon_rarity TEXT NOT NULL CHECK (weapon_rarity IN ('common', 'uncommon', 'rare', 'legendary')),
  weapon_effect TEXT NOT NULL CHECK (weapon_effect IN ('burning', 'poisoned', 'electrified', 'rusted')),
  damage_taken INTEGER NOT NULL CHECK (damage_taken > 0)
);

INSERT INTO damage_logs (id, username, damage_timestamp, weapon_name, weapon_rarity, weapon_effect, damage_taken) VALUES
  (1, 'ArthasMain', '2026-06-12 19:04:05', 'sword', 'common', 'rusted', 18),
  (2, 'MoonPriest', '2026-06-12 19:04:22', 'mace', 'uncommon', 'electrified', 12),
  (3, 'xCalibur', '2026-06-12 19:04:41', 'axe', 'common', 'burning', 15),
  (4, 'GromByte', '2026-06-12 19:05:07', 'dagger', 'common', 'poisoned', 9),
  (5, 'xCalibur', '2026-06-12 19:05:16', 'sword', 'uncommon', 'rusted', 11),
  (6, 'ShieldTotem', '2026-06-12 19:05:31', 'mace', 'rare', 'electrified', 14),
  (7, 'xCalibur', '2026-06-12 19:05:54', 'axe', 'uncommon', 'burning', 17),
  (8, 'VoidCook', '2026-06-12 19:06:03', 'sword', 'common', 'rusted', 8),
  (9, 'xCalibur', '2026-06-12 19:06:19', 'mace', 'rare', 'electrified', 13),
  (10, 'EluneKid', '2026-06-12 19:06:43', 'dagger', 'common', 'poisoned', 10),
  (11, 'xCalibur', '2026-06-12 19:06:55', 'sword', 'rare', 'burning', 16),
  (12, 'RuneTank', '2026-06-12 19:07:12', 'axe', 'uncommon', 'rusted', 20),
  (13, 'xCalibur', '2026-06-12 19:07:24', 'mace', 'rare', 'electrified', 12),
  (14, 'xCalibur', '2026-06-12 19:07:41', 'dagger', 'legendary', 'poisoned', 34);
