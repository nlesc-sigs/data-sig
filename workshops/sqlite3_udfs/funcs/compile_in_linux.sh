gcc -lm -fPIC -DSQLITE_CORE -shared nlesc_udfs.c -o libnlescudfs.so

#You must have installed mingw
i586-mingw32msvc-gcc -g -shared nlesc_udfs.c -o libnlescudfs.dll


gcc -fPIC -shared extension-functions.c -o libextensionfunctions.so -lm
i586-mingw32msvc-gcc -g -shared extension-functions.c -o libextensionfunctions.dll
