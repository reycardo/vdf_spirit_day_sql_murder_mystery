DROP TABLE IF EXISTS clues;
DROP TABLE IF EXISTS suspects;

CREATE TABLE suspects (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  alibi TEXT,
  suspicious_score INTEGER NOT NULL
);

CREATE TABLE clues (
  id INTEGER PRIMARY KEY,
  suspect_id INTEGER NOT NULL,
  location TEXT NOT NULL,
  note TEXT NOT NULL,
  FOREIGN KEY (suspect_id) REFERENCES suspects(id)
);

INSERT INTO suspects (id, name, alibi, suspicious_score) VALUES
  (1, 'Avery Quinn', 'At the gym from 6PM to 7PM', 18),
  (2, 'Jordan Hale', 'Working late in office B', 73),
  (3, 'Mika Stone', 'Dinner downtown with friends', 41),
  (4, 'Noah Cruz', 'Watching a film at home', 29);

INSERT INTO clues (suspect_id, location, note) VALUES
  (2, 'Hallway camera', 'Seen near the trophy room at 6:34PM'),
  (2, 'Storage room', 'Fingerprint found on a broken glass case'),
  (3, 'Parking lot', 'Car entered at 6:20PM and left 8:10PM'),
  (1, 'Locker room', 'Bag contained a duplicate keycard');
