# Blazegraph with solr

## Preperation
Prequisites:
* Java 7

Download and unzip [the latest version of solr](http://www.apache.org/dyn/closer.lua/lucene/solr/6.4.1).

Download and unzip [blazegraph](https://www.blazegraph.com/download/). What we will need is the jar-file `blazegraph.jar`


## Setting up solr
From this directory, launch the `hogeraad` solr server:

`<path/to/solr/>bin/solr start -p 8983 -s <absolute/path/to/ldm-sig>/workshops/solr-blazegraph/solr`

You can browse to `localhost:8983` to explore the solr instance.

Then load the data into solr:

`curl --header "Content-Type: text/xml" --data-binary @data/caselaw.xml http://localhost:8983/solr/hogeraad/update`

It has now loaded 10 documents into solr. Let's try out a query:

`http://localhost:8983/solr/hogeraad/select?q=content:turkse&wt=json`


