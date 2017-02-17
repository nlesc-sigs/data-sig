#ifndef NLESC_UDFS_DLL_H
#define NLESC_UDFS_DLL_H

#ifdef BUILDING_NLESC_UDFS_DLL
#define NLESC_UDFS_DLL __declspec(dllexport)
#else
#define NLESC_UDFS_DLL __declspec(dllimport)
#endif

int __stdcall SQLITE_NLESC_UDFS_DLL sqlite3_nlesc_udfs_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi);

#endif  // EXAMPLE_DLL_H
