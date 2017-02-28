#ifndef NLESCUDFS_DLL_H
#define NLESCUDFS_DLL_H

#ifdef BUILDING_NLESC_UDFS_DLL
#define NLESCUDFS_DLL __declspec(dllexport)
#else
#define NLESCUDFS_DLL __declspec(dllimport)
#endif

int __stdcall SQLITE_NLESCUDFS_DLL sqlite3_nlescudfs_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi);

#endif  // EXAMPLE_DLL_H
