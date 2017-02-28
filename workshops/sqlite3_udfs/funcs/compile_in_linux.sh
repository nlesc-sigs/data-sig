gcc -lm -fPIC -DSQLITE_CORE -shared nlesc_udfs.c -o libnlescudfs.so

#You must have installed mingw
i586-mingw32msvc-gcc -g -shared nlesc_udfs.c -o libnlescudfs.dll
