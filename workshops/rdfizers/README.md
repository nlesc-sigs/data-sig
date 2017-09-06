## RDFizers at the core of Semantic Web/Linked Data technologies

**Use case**: Generate semantically interoperable genome annotations in RDF using (semi-)automated approaches [1].

**1. Introduction**:
* [RDF](https://www.w3.org/RDF/) graph model (serializations) & [Linked Data principles](https://www.w3.org/DesignIssues/LinkedData.html)
* Genome annotations commonly store and shared via tab-delimited files in Generic Feature Format ([GFF](https://github.com/The-Sequence-Ontology/Specifications/blob/master/gff3.md))

* Controlled vocabularies, taxonomies & ontologies ([GenBank Feature Table Definition](http://www.insdc.org/documents/feature-table), [NCBITaxon](https://github.com/obophenotype/ncbitaxon), [SO[FA]](http://www.sequenceontology.org/), [FALDO](https://github.com/JervenBolleman/FALDO))
* Metadata standards & PIDs ([Dublin Core/DCMI](http://dublincore.org/documents/dcmi-terms/), [DCAT](https://www.w3.org/TR/vocab-dcat/), [Cool URIs](https://www.w3.org/TR/cooluris/) or [PURLs](https://github.com/OBOFoundry/purl.obolibrary.org/))
* RDFication approaches:
  * text file (GFF)-> RDB -> RDF (SIGA.py)
  * text file -> RDF (OpenRefine+RDF, Virtuoso Sponger)
  * [RDB->RDF](http://rdb2rdf.org/): Direct Mapping or R2RML (Virtuoso R2RML processor)

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

**3. Install & test [OpenRefine](http://openrefine.org/) with RDF extension**

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

* upload RDF graphs: follow _Linked_Data_->_Quad Store Upload_->_File_ and _Named Graph URI_
  * tomato gene models: `siga/examples/features.ttl` with  `http://solgenomics.net/genome/Solanum_lycopersicum` graph URI
  * tomato QTLs: `pbg-ld/data/rdf/tomato_QTLs.ttl.gz` with `http://europepmc.org/articles` graph URI

* query RDF graphs via [SPARQL](http://localhost:8890/sparql) endpoint

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

**References**

[1] NLeSC [candYgene](https://www.esciencecenter.nl/project/prediction-of-candidate-genes-for-traits-using-interoperable-genome-annotat) project & code base on [GitHub](https://github.com/candYgene)
