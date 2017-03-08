## Extending SQLite functionality: User Defined Functions (UDFs) in Python

**Use case**: Compute some statistics on an example proteomics data set stored in SQLite db [1].

**Input data**: relative protein abundance between two experimental conditions (SILAC ratios) in [TSV](PROTEIN.dat) format:
* 1st column - (internal) protein IDs
* 2nd column - protein abundance (from 0 to inf.)

**1. Create db and import protein data:**

`sqlite3 test.db < create_db.sql`

**2. Analyze data stored in the db using UDFs:**

`python udfs.py test.db`

**Output data:**

|stat|value
|----|---
n|	3422
min|	-5.2593
max|	4.4178
mean|	-0.0168
median|	0.0175
stdev|	0.6311
mad|	0.147

Note: The values are based on _log_-transformed SILAC data (except for `n`).

There are *two types of UDFs* used in this example [2]:
* _"simple"_ SQL functions implemented as Python functions (e.g. `log`)
* _aggregate_ SQL functions implemented as Python classes (`Median`, `Stdev` and `Mad`)

**References:**

[1] Kuzniar and Kanaar (2014) PIQMIe: a web server for semi-quantitative proteomics data management and analysis, _Nucleic Acids Res_, 42, W100-W106. DOI:[10.1093/nar/gku478](https://doi.org/10.1093/nar/gku478)

[2] `sqlite3`DB-API 2.0 interface [documentation](https://docs.python.org/3/library/sqlite3.html)
