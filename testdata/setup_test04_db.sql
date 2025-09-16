CREATE SCHEMA IF NOT EXISTS facts;

CREATE OR REPLACE TABLE facts.databases (
    name VARCHAR NOT NULL,
    year INTEGER,
    PRIMARY KEY (name)
);


CREATE OR REPLACE TABLE facts.countries (
    name VARCHAR NOT NULL,
    population INTEGER,
    capital VARCHAR,
    PRIMARY KEY (name)
);

INSERT INTO facts.databases
VALUES
    ('DuckDB', 2019),
    ('SQLite', 2000);

