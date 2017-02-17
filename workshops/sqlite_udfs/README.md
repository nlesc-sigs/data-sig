#SQLite extended functionality
SQLite allows new functionality to be added using the C/C++ interface, more information can be found at [SQLite Run-time Loadable Extensions](http://sqlite.org/loadext.html).

#SQLite extensions example
An example of an extension with several functions can be found in [funcs/nlesc_udfs.c](funcs/nlesc_udfs.c) to which an user can add more functions to SQLite.
Functions in an extension are defined as follow:
```
#Define the user's C function

#Define the C function to extend SQLite

#Register the function

```

##Compilation
It is required to have SQLite 3.0 installed and access to the sqlite3_ext header file, sqlite3 header file is not enough.

###Compilation on Linux for Linux.
For Linux we need to create a .so file. To create such file run the following command:
```
gcc -lm -fPIC -DSQLITE_CORE -shared nlesc_udfs.c -o libnlescudfs.so
```

###Compilation on Linux for windows.
For windows we need to create a .ddl file. To create such file run the following command:
```
gcc -lm -fPIC -DSQLITE_CORE -shared nlesc_udfs.c -o libnlescudfs.so
```

For windows we need to create a .dll file. To create such file in Linux to then be used in Windows you need to compile the library using mingw (32 and 64 bist windows).
We have tested using Ubuntu for compilation and Windows 7 for execution.

Installation of mingw on Ubuntu:
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

###Compilation on Windows for Windows
To compile for Windows using MinGW, the command line is just like it is for unix except that the output file suffix is changed to ".dll" and the -fPIC argument is omitted.
Note that dll created with this approach is slightly different from the one created using mingw in Linux. While the linux version works well when loaded directly on SQLite3 SQL interface, this one type of compilation is required when using SQLite from javascript. In this case, it is necessary to include the location where the binaries and sources are located.
```
gcc -g -shared nlesc_udfs.c -o libnlescudfs.dll -I<path_to_sqlite_binaries_sources>/sqlite-autoconf-3160200
```

##Load extension and call a function from SQL

To load an extension the user should do the following:
```
#Load the module
.load '<path_to_module.[so|dll]>/libnlescudfs
```

To call the function from SQL the user should do the following:
```
#Simple call where a file will be created with a lit of text containing <query_id>:int and <query>:str.
select example_query(<query_id>, <query>);
```

##Third party extension
Here you can find interesting extensions to SQLite3 which are not part of SQLite3 core functionality, to be used at your own risk.
The one we think has more emphasis for work done at the Netherlands eScience center is the extension for [Mathematical and string functions](funcs/extension-functions.c) retrieved from [SQLite3 web-site](https://www.sqlite.org/contrib).

> "extension-functions.c (50.96 KB) contributed by Liam Healy on 2010-02-06 15:45:07
> Provide mathematical and string extension functions for SQL queries using the loadable extensions mechanism. Math: acos, asin, atan, atn2, atan2, acosh, asinh, atanh, difference, degrees, radians, cos, sin, tan, cot, cosh, sinh, tanh, coth, exp, log, log10, power, sign, sqrt, square, ceil, floor, pi. String: replicate, charindex, leftstr, rightstr, ltrim, rtrim, trim, replace, reverse, proper, padl, padr, padc, strfilter. Aggregate: stdev, variance, mode, median, lower_quartile, upper_quartile."
