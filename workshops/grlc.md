# GRLC - Builds Web APIs from SPARQL queries

Everyone should agree that it is generally a good practice to separate data from processing. In the context of SPARQL queries, it seems like a good idea to have SPARQL queries separate from result visualization. In my case, that meant NOT having SPARQL queries as part of a JavaScript application.

In this tutorial, we will use [`grlc`](https://github.com/CLARIAH/grlc) to create a web API from existing SPARQL queries, hosted on github. In my particular case, my SPARQL queries are hosted [here: https://github.com/DivePlus/dbpedia-queries](https://github.com/DivePlus/dbpedia-queries). Notice that we have some fields at the top of the file which begin with `#+ `, these are grlc parameters to configure our query. Also notice that some variables start with `?_` (for instance `?_keywordsList` in [getSearchQuery](https://github.com/DivePlus/dbpedia-queries/blob/master/getSearchQuery.rq)) -- these are BASIL parameters and will become the parameters for our web API.

Let's start by installing `grlc` python package. Simply type:

```
pip install grlc
```

Once installed, you should have the `grlc-server` command available. So we can start the grlc server by typing:

```
grlc-server
```

Once this is done, you will have a grlc server running locally on `http://localhost:8088/`. We want to create a web API for queries on the github repo `DivePlus/dbpedia-queries`, so we just need to open a browser and go to:

```
http://localhost:8088/api/DivePlus/dbpedia-queries/
```

And we have a web interface to use our queries!

For example we could run our getSearchQuery as follows (notice the `keywordsList` parameter):
```
curl -X GET --header "Accept: application/json" "http://localhost:8088/api/DivePlus/dbpedia-queries/getSearchQuery?keywordsList=Frida"
```

## Using grlc programatically

But what if we wanted to use grcl from within Python? Perhaps because we want to transform the output of grlc using `jq`?

Let's first install jq for python:

```
pip install jq
```

Now, let's see how we can use grlc within python:

```
# First we import a couple of grlc functions
from grlc.utils import build_spec
from grlc.gquery import rewrite_query

# And we build our spec from github user: DivePlus using repo: dbpedia-queries
spec = build_spec('DivePlus', 'dbpedia-queries')

# I'll repackage our spec by call_name
spec_dict = { entry['call_name']:entry for entry in spec }

# And this is the endpoint we sant to use
endpoint = 'http://dbpedia.org/sparql/'

# Let's use getSearchQuery again
searchQuery = spec_dict['getSearchQuery']

# And just to be sure, let's make sure it takes a parameter called keywordsList
assert 'keywordsList' in [ p['name'] for p in searchQuery['params'] ]

# Now we replace the keywordsList parameter for it's desired value
query = rewrite_query(searchQuery['query'], {'keywordsList': 'Frida'}, endpoint)

print 'We will run query: \n\n%s\n  using endpoint: %s'%(query,endpoint)

# Now let's use SPARQLWrapper to run the query
from SPARQLWrapper import SPARQLWrapper, JSON
from jq import jq

sparql = SPARQLWrapper(endpoint=endpoint)
sparql.setMethod('GET')
sparql.setReturnFormat(JSON)
sparql.setQuery(query)
result = sparql.query().convert()

# And use JQ to transform our results
jq_code = "[ .results.bindings[] | [ .entity.value, .label.value ] ]"
transformedResult = jq(jq_code).transform(result)
for tr in transformedResult:
    print tr
```

And we are done!
