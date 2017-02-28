import math
import numpy as np
import sqlite3 as sqlt

dbfile = 'test.db'

# user-defined (aggregate) functions (UDFs); https://docs.python.org/2/library/sqlite3.html
def log(value, base):
    try:
        return math.log(value) / math.log(base)
    except:
        return None
        
class Stdev: # sample standard deviation (aggregate function)
    def __init__(self):
        self.vec = []

    def step(self, value):
        self.vec.append(value)

    def finalize(self):
        return np.array(self.vec).std(ddof=1)

class Median: # median (aggregate function)
    def __init__(self):
        self.arr = []

    def step(self, value):
        self.arr.append(value)

    def finalize(self):
        return np.median(np.array(self.arr))

class Mad: # median absolute deviation (aggregate function)
    def __init__(self):
        self.arr = []

    def step(self, value):
        self.arr.append(value)

    def finalize(self):
        median = np.median(np.array(self.arr))
        return np.median(np.abs(self.arr - median))

# connect to db
with sqlt.connect(dbfile) as conn:
   conn.row_factory = sqlt.Row # enable column access by name: row['colnm']
   conn.create_function('log', 2, log)
   conn.create_aggregate('stdev', 1, Stdev)
   conn.create_aggregate('median', 1, Median)
   conn.create_aggregate('mad', 1, Mad)
   cur = conn.cursor()
   sql_stmt = """
      SELECT
         ROUND(AVG(LOG(abundance, 10)), 4) AS mean,
         ROUND(STDEV(LOG(abundance, 10)), 4) AS stdev,
         ROUND(MEDIAN(LOG(abundance, 10)), 4) AS median,
         ROUND(MAD(LOG(abundance, 10)), 4) AS mad
      FROM
         PROTEIN
   """

   cur.execute(sql_stmt)
   for row in cur.fetchall():
      print(row)
