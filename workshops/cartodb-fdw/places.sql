CREATE TABLE places (
  id integer NOT NULL, location geometry
);
GRANT SELECT ON places TO bob;

INSERT INTO places VALUES (1, ST_SetSRID(ST_MakePoint(4.953985,52.356905), 4326));
INSERT INTO places VALUES (2, ST_SetSRID( ST_MakePoint(4.955541,52.354509), 4326));
