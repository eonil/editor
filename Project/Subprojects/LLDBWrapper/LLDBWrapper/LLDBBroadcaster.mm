//
//  LLDBBroadcaster.m
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#import "LLDBBroadcaster.h"
#import "LLDB_Internals.h"

@implementation LLDBBroadcaster
LLDBOBJECT_INIT_IMPL(lldb::SBBroadcaster)
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}
- (instancetype)initWithName:(NSString *)name
{
	return	[self initWithCPPObject:lldb::SBBroadcaster(name.UTF8String)];
}

- (void)broadcastEvent:(LLDBEvent *)event unique:(BOOL)unique
{
	_raw.BroadcastEvent(event->_raw, unique);
}
- (void)broadcastEventByType:(uint32_t)eventType unique:(BOOL)unique
{
	_raw.BroadcastEventByType(eventType, unique);
}








- (BOOL)isEqualToBroadcaster:(LLDBBroadcaster *)broadcaster
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(broadcaster, LLDBBroadcaster);
	
	return	_raw.operator==(broadcaster->_raw);
}
- (BOOL)isEqualTo:(id)object
{
	if ([object isKindOfClass:[LLDBBroadcaster class]])
	{
		return	[self isEqualToBroadcaster:object];
	}
	return	NO;
}
- (BOOL)isEqual:(id)object
{
	return	[self isEqualTo:object];
}

- (NSString *)description
{
	UNIVERSE_DELETED_METHOD();
}
@end
