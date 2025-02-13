CREATE TABLE IF NOT EXISTS crosswords (
    awake TEXT PRIMARY KEY,
    label TEXT,
    questions JSON
);
-- ;
CREATE TABLE IF NOT EXISTS crosswords_response (
    awake TEXT,
    position INTEGER,
    response TEXT,
    PRIMARY KEY (awake, position),
    FOREIGN KEY (awake) REFERENCES crosswords(awake)
);
