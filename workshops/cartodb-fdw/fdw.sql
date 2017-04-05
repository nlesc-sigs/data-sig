CREATE EXTENSION postgres_fdw;
CREATE SERVER remotedb FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'some-postgres', port '5432', dbname 'somedb');
CREATE FOREIGN TABLE places (id integer NOT NULL, location geometry) SERVER remotedb OPTIONS (table_name 'places');
CREATE USER bob PASSWORD 'secret';
GRANT SELECT ON places TO bob;
GRANT USAGE ON FOREIGN SERVER remotedb TO bob;
