DROP TABLE IF EXISTS weapon_effects;

CREATE TABLE weapon_effects (
  weapon_effect TEXT PRIMARY KEY CHECK (weapon_effect IN ('burning', 'poisoned', 'electrified', 'rusted')),
  damage_increment INTEGER NOT NULL
);

INSERT INTO weapon_effects (weapon_effect, damage_increment) VALUES
  ('burning', 5),
  ('poisoned', 10),
  ('electrified', 15),
  ('rusted', -5);
