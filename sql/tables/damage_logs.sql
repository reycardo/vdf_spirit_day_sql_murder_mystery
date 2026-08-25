DROP TABLE IF EXISTS damage_logs;

CREATE TABLE damage_logs (
  id INTEGER PRIMARY KEY,
  username TEXT NOT NULL,
  damage_timestamp TEXT NOT NULL,
  damage_taken INTEGER NOT NULL CHECK (damage_taken > 0)
);

INSERT INTO damage_logs (id, username, damage_timestamp, damage_taken) VALUES
  (1, 'ArthasMain', '19:04', 18),
  (2, 'MoonPriest', '19:04', 12),
  (3, 'xCalibur', '19:04', 15),
  (4, 'GromByte', '19:05', 9),
  (5, 'xCalibur', '19:05', 11),
  (6, 'ShieldTotem', '19:05', 14),
  (7, 'xCalibur', '19:05', 17),
  (8, 'VoidCook', '19:06', 8),
  (9, 'xCalibur', '19:06', 13),
  (10, 'EluneKid', '19:06', 10),
  (11, 'xCalibur', '19:06', 16),
  (12, 'RuneTank', '19:07', 20),
  (13, 'xCalibur', '19:07', 12),
  (14, 'xCalibur', '19:07', 34);
