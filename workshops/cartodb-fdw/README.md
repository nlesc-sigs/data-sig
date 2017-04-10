Workshop about [Carto](https://carto.com) and foreign data wrappers.

# Carto

Host own Carto instance by following instructions at https://hub.docker.com/r/sverhoeven/cartodb/.

Use Firefox as other browsers have problems with \*.localhost domain.

## Download test data set

Bird tracking data from https://github.com/inbo/bird-tracking/tree/master/cartodb

Download sample dataset from [http://lifewatch.cartodb.com/api/v2/sql?format=geojson&q=SELECT * FROM bird_tracking WHERE device_info_serial=5065 AND date_time BETWEEN '2015-03-15' AND '2015-04-15'](http://lifewatch.cartodb.com/api/v2/sql?format=geojson&q=SELECT+%2A+FROM+bird_tracking+WHERE+device_info_serial%3D5065+AND+date_time+BETWEEN+%272015-03-15%27+AND+%272015-04-15%27)

The selected tracker 5065 is flown around by Roxanne a female Lesser Black-backed Gull.

## Load data into Carto

1. Press `new map` button
2. Click `connect dataset` link
3. Upload `cartodb-query.geojson` file
4. Press `create map` button

## Customize map

#### Map options

Enable scroll wheel zoom.

#### Base map

Choose black background without labels.

Base maps by Carto or NASA, WMS, etc.

#### Style

First select data layer.

Click fill color to change color
Click fill size and click `by value` and select altitude column.

#### Pop up

1. Select POP-UP menu item
2. Select light style
3. Show date_time item
4. Click on point in map to get pop up

#### Widgets

1. Enable widgets for
  * point count
  * data_time
  * satellites_used, set to category type
  * altitude

2. Make some selections

#### Animated time series

Select animation as aggregation.

Uses [Torque](https://github.com/CartoDB/torque) layer cube format.

Example https://jshamoun.carto.com/viz/8796d368-79b8-11e5-a233-0e3ff518bd15/public_map

#### Analysis

Select analysis menu item
Select detect outliers and clusters
Select altitude as target column
Click apply

Fill color by quads

#### Publish

1. Click on private to switch it to public.
2. Click on publish
3. Click on share to get a link or embed snippet.

## Query data

1. Goto data sets
2. Select data set
3. Switch to SQL mode

In SQL mode you can join other tables, use postgis functions.

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
