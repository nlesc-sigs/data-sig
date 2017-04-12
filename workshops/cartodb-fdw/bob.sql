CREATE USER MAPPING FOR CURRENT_USER SERVER remotedb OPTIONS (user 'bob', password 'secret');
SELECT
  row_number() OVER(ORDER BY id) AS cartodb_id,
  location AS the_geom,
  ST_Transform(location, 3857) AS the_geom_webmercator,
  ST_X(location) AS longitude,
  ST_Y(location) AS latitude
FROM places;
