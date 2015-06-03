//
//  CoreBridge
//  EonilSQLite3
//
//  Created by Hoon H. on 9/15/14.
//
//

#include <stdio.h>
#include "CoreBridge.h"






/*!
 @ref	http://www.sqlite.org/c3ref/set_authorizer.html
 @ref	http://www.sqlite.org/c3ref/c_alter_table.html
 */
static inline int
CoreBridge____sqlite3_authorization_callback(void* userData, int actionCode, const char* argA, const char* argB, const char* argC, const char* argD) {
	Eonil____SQLite3____Bridge____CallbackProxy*	p1	=	(__bridge  Eonil____SQLite3____Bridge____CallbackProxy*)userData;
	return	[p1 authoriseActionCode:actionCode :argA :argB :argC :argD];
}



@implementation Eonil____SQLite3____Bridge____CallbackProxy
- (int)authoriseActionCode:(int)actionCode :(const char *)argA :(const char *)argB :(const char *)argC :(const char *)argD {
	return	SQLITE_OK;
}
+ (int)installAuthorisationCallbackProxy:(Eonil____SQLite3____Bridge____CallbackProxy *)proxy forSQLite3Database:(sqlite3 *)database {
	return	sqlite3_set_authorizer(database, &CoreBridge____sqlite3_authorization_callback, (__bridge void*)proxy);
}
+ (int)uninstallAuthorisationCallbackProxyForSQLite3Database:(sqlite3 *)database {
	return	sqlite3_set_authorizer(database, NULL, NULL);
}
@end

