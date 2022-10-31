# ArangoDB

ArangoDB is a scalable open-source multi-model database natively supporting graph, document and search.

https://www.arangodb.com/ 

Start database with Docker

```shell
docker run -e ARANGO_ROOT_PASSWORD=tutpw -p 8529:8529 arangodb/arangodb:3.9.3
```

Login to http://localhost:8529 with username `root` and password `tutpw`.

Follow tutorial from https://www.arangodb.com/docs/stable/getting-started-web-interface.html
