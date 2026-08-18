DROP TABLE IF EXISTS damage_logs;

CREATE TABLE damage_logs (
  id INTEGER PRIMARY KEY,
  username TEXT NOT NULL,
  damage_timestamp TEXT NOT NULL,
  damage_taken INTEGER NOT NULL CHECK (damage_taken > 0)
);

INSERT INTO damage_logs (id, username, damage_timestamp, damage_taken) VALUES
  (1, 'ArthasMain', '2026-06-12 19:04:05', 18),
  (2, 'MoonPriest', '2026-06-12 19:04:22', 12),
  (3, 'xCalibur', '2026-06-12 19:04:41', 15),
  (4, 'GromByte', '2026-06-12 19:05:07', 9),
  (5, 'xCalibur', '2026-06-12 19:05:16', 11),
  (6, 'ShieldTotem', '2026-06-12 19:05:31', 14),
  (7, 'xCalibur', '2026-06-12 19:05:54', 17),
  (8, 'VoidCook', '2026-06-12 19:06:03', 8),
  (9, 'xCalibur', '2026-06-12 19:06:19', 13),
  (10, 'EluneKid', '2026-06-12 19:06:43', 10),
  (11, 'xCalibur', '2026-06-12 19:06:55', 16),
  (12, 'RuneTank', '2026-06-12 19:07:12', 20),
  (13, 'xCalibur', '2026-06-12 19:07:24', 12),
  (14, 'xCalibur', '2026-06-12 19:07:41', 34);
