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
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.BroadcastEvent(event->_raw, unique);
}
- (void)broadcastEventByType:(uint32_t)eventType unique:(BOOL)unique
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.BroadcastEventByType(eventType, unique);
}






- (uint32_t)addListener:(LLDBListener *)listener eventMask:(uint32_t)eventMask
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(listener, LLDBListener);
	
	return	_raw.AddListener(listener->_raw, eventMask);
}
- (BOOL)removeListener:(LLDBListener *)listener eventMask:(uint32_t)eventMask
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(listener, LLDBListener);
	
	return	_raw.RemoveListener(listener->_raw, eventMask) == true;
}






- (BOOL)isEqualToBroadcaster:(LLDBBroadcaster *)broadcaster
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
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
