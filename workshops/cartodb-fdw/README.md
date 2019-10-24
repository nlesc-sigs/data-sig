Workshop about [Carto](https://carto.com) and foreign data wrappers.

# Carto

Host own Carto instance by following instructions at https://hub.docker.com/r/sverhoeven/cartodb/.

If you have problems with \*.localhost domain use Firefox or a different hostname (e.g. `docker run -d -p 80:80 -e CARTO_HOST=cartodb.example.com sverhoeven/cartodb`).

## Download test data set

Bird tracking data from https://github.com/inbo/bird-tracking/tree/master/cartodb

Download sample dataset from [http://lifewatch.cartodb.com/api/v2/sql?format=geojson&q=SELECT t.*, d.bird_name, d.sex, d.scientific_name FROM bird_tracking t JOIN bird_tracking_devices d USING (device_info_serial) WHERE date_time BETWEEN '2015-03-01' AND '2015-04-30'](http://lifewatch.cartodb.com/api/v2/sql?format=geojson&q=SELECT%20t.*%2C%20d.bird_name%2C%20d.sex%2C%20d.scientific_name%20FROM%20bird_tracking%20t%20JOIN%20bird_tracking_devices%20d%20USING%20%28device_info_serial%29%20WHERE%20date_time%20BETWEEN%20%272015-03-01%27%20AND%20%272015-04-30%27) of 5 birds in March/April 2015.

## Load data into Carto

1. Press `new map` button
2. Click `connect dataset` link
3. Upload `cartodb-query.geojson` file
4. Press `create map` button

## Customize map

#### Base map

Choose black background without labels.

Base maps by Carto or NASA, WMS, etc.

#### Style

1. First select data layer.
2. Click point color to change solid color
3. Click fill size and click `by value` and select bird_name column.

#### Pop up

1. Select POP-UP menu item
2. Select light style
3. Show date_time and bird_name items
4. Click on point in map to get pop up

#### Widgets

1. Enable widgets for
  * feature count
  * date_time
  * bird_name
  * sex
  * scientific_name
  * altitude

2. Make some selections

#### Animated time series

1. Select animated as aggregation
2. Select source-over as blending
3. Select date_time as column
4. Drag stroke size to 0
5. Click fill size and click `by value` and select bird_name column.

Uses [Torque](https://github.com/CartoDB/torque) layer cube format.

Example https://jshamoun.carto.com/viz/8796d368-79b8-11e5-a233-0e3ff518bd15/public_map

#### Analysis

1. Select analysis menu item
2. Select detect outliers and clusters
3. Select altitude as target column
4. Click apply

5. Select single bird
6. Fill color by quads

#### Publish

1. Click on private to switch it to public.
2. Click on publish
3. Click on publish again
4. Goto publish tab to get a link or embed snippet.

## Query data

1. Goto data sets
2. Select data set
3. Switch to SQL mode

In SQL mode you can join other tables, use postgis functions.

For example to compute daily distance:
```sql
SELECT 
  row_number() OVER(ORDER BY bird_name, date) AS cartodb_id,
  a.*,
  round((ST_Length_Spheroid(the_geom,'SPHEROID["WGS 84",6378137,298.257223563]')/1000.0)::numeric, 3) AS distance,
  ST_Transform(the_geom, 3857) AS the_geom_webmercator
FROM (
  SELECT
	   bird_name, 
  	 date(date_time) as date,
    count(*) as fixes,
    ST_MakeLine(the_geom ORDER BY date_time) AS the_geom,
    max(altitude) as maxalt, round(avg(altitude)::numeric, 2) as avgalt, min(altitude) as minalt
  FROM admin4example.mytable t  
  GROUP BY bird_name, date(date_time)
) a
```
(replace `mytable` with name of table)

The result can be materialized by creating a dataset from the query.

# Foreign data wrappers

## Create some PostgreSQL server

```
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -v $PWD:/data -d mdillon/postgis
docker exec -it some-postgres bash -c 'psql -U postgres < /data/createdb.sql && psql -U bob somedb < /data/places.sql'
```

Creates a `places` table inside the `somedb` database which is owned by `bob` account who has password `secret`.

## Connect from other PostgreSQL server to some PostgreSQL server

```
docker run --name other-postgres --link some-postgres -e POSTGRES_PASSWORD=mysecretpassword -v $PWD:/data -d mdillon/postgis
docker exec -it other-postgres bash
psql -U postgres < /data/fdw.sql
psql -U bob postgres < /data/bob.sql
```

Bob account on this server can read the places table on the remote server.
