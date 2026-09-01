CREATE TABLE marks (
    id SERIAL PRIMARY KEY,
    name TEXT,
    marks INT NOT NULL
);

INSERT INTO marks (name, marks)
SELECT
    substr(
        translate(
            md5(random()::text || gs::text),
            'abcdefghijklmnopqrstuvwxyz',
            'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        ),
        1,  
        12
    ) AS name,
    floor(random() * 100 + 1)::int AS marks

FROM generate_series(1, 1000000) AS gs;

SELECT * FROM marks;

EXPLAIN ANALYZE SELECT * FROM marks WHERE name='CE20EAF2F6E8'; -- Triggers a parallel seq scan

CREATE INDEX idx_name ON marks (name); -- Triggers an index scan (record location saved in index table (B+ Tree))
-- CREATE INDEX idx_name CONCURRENTLY ON marks (name); -- creates the index without taking a lock that prevents concurrent inserts
DROP INDEX idx_name;

CREATE INDEX idx_name ON marks (name) INCLUDE(marks); -- Triggers an index only scan (record details saved in index table too)
                         -- table             -- column
EXPLAIN ANALYZE SELECT marks FROM marks WHERE name='CE20EAF2F6E8'; -- Triggers a parallel seq scan

-- ! Note: This does lead to increase in write times tho, as the DB has to write in two places instead of one
-- * Does improve Read times drastically tho (kinda acts like a cache, although not technically)
