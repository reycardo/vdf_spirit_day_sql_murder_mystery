DROP TABLE IF EXISTS player_overview;

CREATE TABLE player_overview (
  id INTEGER PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  class TEXT NOT NULL CHECK (class IN ('warrior', 'mage', 'rogue', 'bard')),
  current_equipped_weapon TEXT NOT NULL CHECK (current_equipped_weapon IN ('sword', 'axe', 'dagger', 'staff')),
  current_weapon_effect TEXT NOT NULL CHECK (current_weapon_effect IN ('burning', 'poisoned', 'electrified', 'rusted'))
);

INSERT INTO player_overview (id, username, class, current_equipped_weapon, current_weapon_effect) VALUES
  (1, 'ArthasMain', 'warrior', 'sword', 'electrified'),
  (2, 'MoonPriest', 'bard', 'dagger', 'rusted'),
  (3, 'xCalibur', 'rogue', 'dagger', 'burning'),
  (4, 'RuneTank', 'warrior', 'axe', 'poisoned'),
  (5, 'EluneKid', 'rogue', 'sword', 'electrified'),
  (6, 'GromByte', 'bard', 'axe', 'burning'),
  (7, 'ShieldTotem', 'rogue', 'sword', 'poisoned'),
  (8, 'VoidCook', 'mage', 'dagger', 'poisoned'),
  (9, 'easily_gullible123', 'rogue', 'dagger', 'electrified'),
  (10, 'NightOwlKit', 'bard', 'axe', 'electrified'),
  (11, 'PixelPaladin', 'bard', 'sword', 'poisoned'),
  (12, 'SoggyWizard', 'bard', 'axe', 'poisoned'),
  (13, 'GrumpyBard', 'warrior', 'axe', 'burning'),
  (14, 'TinyTitan', 'warrior', 'axe', 'rusted'),
  (15, 'SilentArrow', 'rogue', 'sword', 'electrified'),
  (16, 'CrimsonFang', 'bard', 'dagger', 'burning'),
  (17, 'FrostByte99', 'warrior', 'sword', 'burning'),
  (18, 'WanderingSage', 'mage', 'staff', 'rusted'),
  (19, 'IronCladLuna', 'mage', 'dagger', 'burning'),
  (20, 'MysticRogue7', 'mage', 'staff', 'poisoned'),
  (21, 'BlazeRunner', 'bard', 'sword', 'rusted'),
  (22, 'ShadowMend', 'warrior', 'dagger', 'rusted'),
  (23, 'GoldenTusk', 'rogue', 'sword', 'rusted'),
  (24, 'VelvetHex', 'warrior', 'dagger', 'poisoned'),
  (25, 'ThunderClap22', 'rogue', 'dagger', 'burning'),
  (26, 'MossyBoulder', 'bard', 'axe', 'rusted'),
  (27, 'EchoWisp', 'mage', 'staff', 'electrified'),
  (28, 'GrittyGnome', 'warrior', 'sword', 'electrified'),
  (29, 'AzureFalcon', 'warrior', 'sword', 'poisoned'),
  (30, 'NoobSlayer42', 'bard', 'sword', 'electrified'),
  (31, 'QuietStorm', 'mage', 'dagger', 'electrified'),
  (32, 'PebblePirate', 'warrior', 'axe', 'rusted'),
  (33, 'WhimsyKnight', 'bard', 'dagger', 'poisoned');
