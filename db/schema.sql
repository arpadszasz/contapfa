BEGIN TRANSACTION;

PRAGMA foreign_keys = ON;
PRAGMA encoding = "UTF-8";

CREATE TABLE metadata (
    id          INTEGER PRIMARY KEY ASC,
    version     VARCHAR(16),
    release     TIMESTAMP NOT NULL
);

INSERT INTO metadata (id, version, release) VALUES (1, "1.0", datetime('now', 'localtime'));

COMMIT;

