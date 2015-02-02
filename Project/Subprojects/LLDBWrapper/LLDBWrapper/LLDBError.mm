//
//  LLDBError.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBError.h"
#import "LLDB_Internals.h"

@implementation LLDBError
LLDBOBJECT_INIT_IMPL(lldb::SBError);
+ (LLDBError *)errorWithMaybeCPPObject:(lldb::SBError)maybeCPPObject
{
	if (maybeCPPObject.IsValid())
	{
		return	[[LLDBError alloc] initWithCPPObject:maybeCPPObject];
	}
	else
	{
		return	nil;
	}
}



- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}




- (NSString *)string
{
	return	fromC(_raw.GetCString());
}
- (uint32_t)error
{
	return	_raw.GetError();
}
- (LLDBErrorType)type
{
	return	fromCPP(_raw.GetType());
}




- (BOOL)isEqualTo:(id)object
{
	UNIVERSE_DELETED_METHOD();
}
- (BOOL)isEqual:(id)object
{
	UNIVERSE_DELETED_METHOD();
}

- (NSString *)description
{
	return	get_description_of(_raw);
}
@end
