## RDFizers at the core of Semantic Web/Linked Data technologies

**Use case**: Generate RDF graphs for (tomato) genome annotations in text files or relational databases using (semi-)automated approaches.

**1. Introduction**:
* RDF graph model (serializations) & Linked Data principles
* Genome annotations commonly stored/shared via tab-delimited file (in Generic Feature Format or GFF)
* Controlled vocabularies, taxonomies & ontologies (GenBank Feature Table Definition, NCBI Taxonomy, SO[FA], FALDO)
* Metadata standards & PIDs (Dublin Core/DCMI, DCAT, Cool URIs or PURLs)
* RDFication approaches:
  * text file (GFF)-> RDB -> RDF (SIGA.py)
  * text file -> RDF (OpenRefine+RDF, Virtuoso Sponger, RML processor)
  * RDB->RDF: Direct Mapping or R2RML (Virtuoso R2RML processor)

**2. Install & test [SIGA.py](https://github.com/candYgene/siga)**

```
git clone https://github.com/candYgene/siga.git
cd siga
virtualenv .sigaenv
source .sigaenv/bin/activate
pip install -r requirements.txt
```

* generate an example graph in RDF (turtle) from GFF

```
cd src
python SIGA.py -h
python SIGA.py db -rV ../examples/features.gff3 # GFF->RDB
sqlite3 ../examples/features.db
python SIGA.py rdf -c config.ini ../examples/features.db # RDB->RDF
ls ../examples.features.ttl
```

**3. Install & test OpenRefine+RDF**

```
docker pull fusepool/openrefine
docker run -p 3333:3333 -d fusepool/openrefine
```

* open `http://localhost:3333/` with your favourite web browser

* import tomato QTL (phenotype) data: _Import_Project_->_Project File_->_Import Project_

```
git clone https://github.com/candYgene/pbg-ld.git
cd pbg-ld/data & tar xvzf sgn-ld.tar.gz
cd data/other
ls tomato_QTLs.openrefine.tar.gz
```

* investigate the tabulated data and RDF schema (data model)

**4. Install & test [OpenLink Virtuoso Universal Server](http://docs.openlinksw.com/virtuoso/)**

```
docker pull candygene/docker-virtuoso
docker run -p 8890:8890 -d candygene/docker-virtuoso
```

* open `http://localhost:8890/` with your favourite web browser and login via [Conductor](http://localhost:8890/conductor/) (`dba` for both account and password)

* upload RDF graphs: follow _Linked_Data->_Quad Store Upload_->_File_ and _Named Graph URI_
  * tomato gene models: `siga/examples/features.ttl` with  `http://solgenomics.net/genome/Solanum_lycopersicum` graph URI
  * tomato QTLs: `pbg-ld/data/rdf/tomato_QTLs.ttl.gz` with `http://europepmc.org/articles` graph URI

* query RDF graphs using [SPARQL](http://localhost:8890/sparql)

```
SELECT *
FROM <http://solgenomics.net/genome/Solanum_lycopersicum>
WHERE { ?s ?p ?o }
```

```
SELECT *
FROM <http://europepmc.org/articles>
WHERE { ?s ?p ?o }
```
