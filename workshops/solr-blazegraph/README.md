# Blazegraph with solr

## Preperation
Prequisites:
* Java 7

Download and unzip [the latest version of solr](http://www.apache.org/dyn/closer.lua/lucene/solr/).

Download and unzip [blazegraph](https://www.blazegraph.com/download/). What we will need is the jar-file `blazegraph.jar`


## Setting up solr
From this directory, launch the `hogeraad` solr server:

`<path/to/solr/>bin/solr start -p 8983 -s <absolute/path/to/ldm-sig>/workshops/solr-blazegraph/solr`

You can browse to `localhost:8983` to explore the solr instance.

Then load the data into solr:

`curl --header "Content-Type: text/xml" --data-binary @data/caselaw.xml http://localhost:8983/solr/hogeraad/update`

(Open question: This doesn't always work. If I manually load a file through the api, they are suddenly all loaded).

It has now loaded 10 documents into solr. Let's try out a query:

`http://localhost:8983/solr/hogeraad/select?q=content:turkse&wt=json`

## Setting up blazegraph
Run from the current directory:
`java -server -Xmx4g -Dbigdata.propertyFile=blazegraph/RWStore.properties -jar <path/to/blazegraph>/blazegraph.jar `

The blazegraph server runs on `localhost:9999`.

Load the n3 files into blazegraph:
`blazegraph/loadRestAPI.sh data/n3/ blazegraph/RWStore.properties`


In the browser, go to `localhost:9999/blazegraph/#query`. Here we can run sparql query.

## (External) full text search
Have a look at the properties file for blazegraph, `blazegraph/RWStore.properties`. As you can see, it contains the property `com.bigdata.rdf.store.AbstractTripleStore.textIndex=true`. This is not the default option! It means that we can do a text search on the fields that we have:

```
PREFIX bds: <http://www.bigdata.com/rdf/search#>

SELECT ?s ?p ?o ?score ?rank
WHERE {
  ?o bds:search "turkse" .
  ?o bds:matchAllTerms "true" .
  ?o bds:relevance ?score .
  ?o bds:rank ?rank .
  ?s ?p ?o .
}
```

If we don't want to store the full text in blazegraph (if we have a large amount of text) we can use the external solr index. Make sure your solr instance is running. Then run the query:
```
PREFIX fts: <http://www.bigdata.com/rdf/fts#>

SELECT ?res WHERE {
  ?res fts:search "content:turkse" .
  ?res fts:endpoint "http://localhost:8983/solr/hogeraad/select" .
  
}
```

Note that the external search returns (default) the id, which we can use to select triples in blazegraph:
```
PREFIX dcterm: <http://purl.org/dc/terms/>
PREFIX fts: <http://www.bigdata.com/rdf/fts#>

SELECT ?id ?date ?title WHERE {
  ?id dcterm:title ?title.
  ?id dcterm:date ?date.
  ?res fts:search "content:turkse" .
  ?res fts:endpoint "http://localhost:8983/solr/hogeraad/select" .
  BIND(URI(?res) as ?id)
}
```
