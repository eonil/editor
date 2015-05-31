//
//  CoreBridge.h
//  EonilSQLite3
//
//  Created by Hoon H. on 9/15/14.
//
//

#pragma once
#import <sqlite3.h>
#import <Foundation/Foundation.h>



/*
 Calls `sqlite3_bind_text` with `SQLITE_TRANSIENT` which is almost impossible to represent in Swift code.
 */
static inline int
CoreBridge____sqlite3_bind_text_transient(sqlite3_stmt* a, int b, const char* c, int d) {
	return	sqlite3_bind_text(a, b, c, d, SQLITE_TRANSIENT);
}

/*
 Calls `sqlite3_bind_blob` with `SQLITE_TRANSIENT` which is almost impossible to represent in Swift code.
 */
static inline int
CoreBridge____sqlite3_bind_blob_transient(sqlite3_stmt* a, int b, const void* c, int d) {
	return	sqlite3_bind_blob(a, b, c, d, SQLITE_TRANSIENT);
}











@interface	Eonil____SQLite3____Bridge____CallbackProxy : NSObject
//- (NSArray*)aliveTableNames;	///!	Returns array of @c NSString\.
- (int)		authoriseActionCode:(int)actionCode :(const char*)argA :(const char*)argB :(const char*)argC :(const char*)argD;
+ (int)		installAuthorisationCallbackProxy:(Eonil____SQLite3____Bridge____CallbackProxy*)proxy forSQLite3Database:(sqlite3*)database;
+ (int)		uninstallAuthorisationCallbackProxyForSQLite3Database:(sqlite3*)database;
@end

//
//typedef int(*CoreBridge____pointer_to_sqlite3_authorize_callback)(void* userData, int actionCode, const char* argA, const char* argB, const char* argC, const char* argD);
//
//static inline CoreBridge____pointer_to_sqlite3_authorize_callback
//CoreBridge____get_pointer_to_sqlite3_authorize_callback() {
//	return	&CoreBridge____sqlite3_authorization_callback;
//}






