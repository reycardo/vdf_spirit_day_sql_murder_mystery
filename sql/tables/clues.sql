DROP TABLE IF EXISTS clues;

CREATE TABLE clues (
  id INTEGER PRIMARY KEY,
  suspect_id INTEGER NOT NULL,
  location TEXT NOT NULL,
  note TEXT NOT NULL,
  FOREIGN KEY (suspect_id) REFERENCES suspects(id)
);

INSERT INTO clues (suspect_id, location, note) VALUES
  (2, 'Hallway camera', 'Seen near the trophy room at 6:34PM'),
  (2, 'Storage room', 'Fingerprint found on a broken glass case'),
  (3, 'Parking lot', 'Car entered at 6:20PM and left 8:10PM'),
  (1, 'Locker room', 'Bag contained a duplicate keycard');
