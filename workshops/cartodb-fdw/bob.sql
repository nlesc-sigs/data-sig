CREATE USER MAPPING FOR CURRENT_USER SERVER remotedb OPTIONS (user 'bob', password 'secret');
SELECT row_number() OVER(ORDER BY id), location the_geom, ST_Transform(location, 3857) AS the_geom_webmercator FROM places;
