DROP TABLE IF EXISTS suspects;

CREATE TABLE suspects (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  alibi TEXT,
  suspicious_score INTEGER NOT NULL
);

INSERT INTO suspects (id, name, alibi, suspicious_score) VALUES
  (1, 'Avery Quinn', 'At the gym from 6PM to 7PM', 18),
  (2, 'Jordan Hale', 'Working late in office B', 73),
  (3, 'Mika Stone', 'Dinner downtown with friends', 41),
  (4, 'Noah Cruz', 'Watching a film at home', 29);
