#SQLite extended functionality
SQLite allows new functionality to be added using the C/C++ interface, more information can be found at [SQLite Run-time Loadable Extensions](http://sqlite.org/loadext.html).

#SQLite extensions example
An example of an extension with several functions can be found in [funcs/nlesc_udfs.c](funcs/nlesc_udfs.c) to which an user can add more functions to SQLite.
Functions in an extension are defined as follow:

[/\*Define the user's C function\*/](funcs/nlesc_udfs.c#L10)

[/\*Define the C function to extend SQLite\*/](funcs/nlesc_udfs.c#L18)

The extension's functions are registered by SQLite3 function **sqlite3_\<name_of_the_extension\>_init**. For **nlesc_udfs** extension the function name is:
[sqlite3_nlescudfs_init](funcs/nlesc_udfs.c#L32)

It is within this function our **example_query** [is registered](funcs/nlesc_udfs.c#L40).
```
int sqlite3_create_function(
  sqlite3 *db,
  const char *zFunctionName,
  int nArg,
  int eTextRep,
  void *pApp,
  void (*xFunc)(sqlite3_context*,int,sqlite3_value**),
  void (*xStep)(sqlite3_context*,int,sqlite3_value**),
  void (*xFinal)(sqlite3_context*)
);
```

##Compilation
It is required to have SQLite 3.0 installed and access to the **sqlite3_ext** header file, sqlite3 header file only is not enough.

###Compilation on Linux for Linux (LL version).
For Linux we need to create a **.so** file. To create such file run the following command:
```
gcc -lm -fPIC -DSQLITE_CORE -shared nlesc_udfs.c -o libnlescudfs.so
```

###Compilation on Linux for windows (LW version).
For windows we need to create a .ddl file. To create such file run the following command:
```
gcc -lm -fPIC -DSQLITE_CORE -shared nlesc_udfs.c -o libnlescudfs.so
```

For windows we need to create a **.dll** file. To create such file in Linux, to then be used in Windows, you need to compile the library using mingw (32 and 64 bist windows).

We have tested it using Ubuntu 14.4 for compilation and Windows 7 for execution. Installation of mingw on Ubuntu:
```
sudo apt-get install mingw64 mingw64-binutils mingw64-runtime
```

After the installation of mingw the default lib and include directories are located at /usr/.
To link with sqlite3 it is required to recompile sqlite3 using mingw.
```
#Get sqlite3
wget http://www.sqlite.org/snapshot/sqlite-snapshot-201701121910.tar.gz
tar -xzf sqlite-snapshot-201701121910.tar.gz
cd sqlite-snapshot-201701121910/
./configure --host=mingw32 CC="i586-mingw32msvc-gcc" --prefix /usr/i586-mingw32msvc/
make
sudo make install
```

Once you have compiled and installed sqlite3 using mingw the next step is to create the .dll file.
```
i586-mingw32msvc-gcc -g -shared nlesc_udfs.c -o libnlescudfs.dll
```

###Compilation on Windows for Windows (WW version)
To compile for Windows using MinGW, the command line is just like the **LL** compilation except that the output file suffix is changed to **.dll** and the **-fPIC** argument is omitted. Furthermore, it is necessary to include the location where the binaries and sources are located.
```
gcc -g -shared nlesc_udfs.c -o libnlescudfs.dll -I<path_to_sqlite_binaries_sources>/sqlite-autoconf-3160200
```

Note that **dll** created with **WW** version is slightly different from the **LW**. While **LW** version works well on SQLite3 SQL for windows, the **WW** was required for SQLite3 embedded in javascript.

##Load extension and call one of its functions from SQL

To load an extension the user should do the following:
```
#Load the module
.load '<path_to_module.[so|dll]>/libnlescudfs
```

To call one of its functions from SQL the user should do the following:
```
#Simple call which will create a file with a line of text containing <query_id>:int and <query>:str. The file will be located at the same directory where SQLite3 SQL was initialized.
select example_query(<query_id>, <query>);
```

##Third party extension
Here you can find interesting extensions to SQLite3 which are not part of SQLite3 core functionality, to be used at your own risk. The one we think has more emphasis for work done at the Netherlands eScience center is the extension for [Mathematical and string functions](funcs/extension-functions.c) retrieved from [SQLite3 web-site](https://www.sqlite.org/contrib).

> "extension-functions.c (50.96 KB) contributed by Liam Healy on 2010-02-06 15:45:07
> Provide mathematical and string extension functions for SQL queries using the loadable extensions mechanism. Math: acos, asin, atan, atn2, atan2, acosh, asinh, atanh, difference, degrees, radians, cos, sin, tan, cot, cosh, sinh, tanh, coth, exp, log, log10, power, sign, sqrt, square, ceil, floor, pi. String: replicate, charindex, leftstr, rightstr, ltrim, rtrim, trim, replace, reverse, proper, padl, padr, padc, strfilter. Aggregate: stdev, variance, mode, median, lower_quartile, upper_quartile."
