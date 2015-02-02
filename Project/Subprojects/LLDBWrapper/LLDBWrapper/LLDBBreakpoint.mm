//
//  LLDBBreakpoint.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/6/14.
//
//

#import "LLDBBreakpoint.h"
#import "LLDB_Internals.h"




static bool default_hit_callback(void *baton, lldb::SBProcess &process, lldb::SBThread &thread, lldb::SBBreakpointLocation &location)
{
	auto const	self	=	(__bridge LLDBBreakpoint*)baton;
	auto const	p		=	[[LLDBProcess alloc] initWithCPPObject:process];
	auto const	t		=	[[LLDBThread alloc] initWithCPPObject:thread];
	auto const	l		=	[[LLDBBreakpointLocation alloc] initWithCPPObject:location];
	auto const	r		=	self.callback(p, t, l);
	return	r;
}






@implementation LLDBBreakpoint
LLDBOBJECT_INIT_IMPL(lldb::SBBreakpoint);



- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}

- (LLDBBreakpointIDType)ID
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetID();
}




- (BOOL)isEnabled
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.IsEnabled() == true;
}
- (void)setEnabled:(BOOL)enabled
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetEnabled(enabled == YES);
}

- (BOOL)isOneShot
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.IsOneShot() == true;
}
- (void)setOneShot:(BOOL)oneShot
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetOneShot(oneShot == YES);
}
- (BOOL)isInternal
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.IsInternal() == true;
}


- (uint32_t)hitCount
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetHitCount();
}
- (uint32_t)ignoreCount
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetIgnoreCount();
}
- (void)setIgnoreCount:(uint32_t)ignoreCount
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetIgnoreCount(ignoreCount);
}
- (NSString *)condition
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	fromC(_raw.GetCondition());
}
- (void)setCondition:(NSString *)condition
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetCondition(condition.UTF8String);
}
- (LLDBThreadIDType)threadID
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetThreadID();
}
- (void)setThreadID:(LLDBThreadIDType)threadID
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetThreadID(threadID);
}
- (uint32_t)threadIndex
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetThreadIndex();
}
- (void)setThreadIndex:(uint32_t)threadIndex
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetThreadIndex(threadIndex);
}
- (NSString *)threadName
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	fromC(_raw.GetThreadName());
}
- (void)setThreadName:(NSString *)threadName
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetThreadName(threadName.UTF8String);
}
- (NSString *)queueName
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	fromC(_raw.GetQueueName());
}
- (void)setQueueName:(NSString *)queueName
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetQueueName(queueName.UTF8String);
}











- (void)setCallback:(LLDBBreakpointHitCallback)callback
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetCallback(nullptr, NULL);
	
	_callback	=	[callback copy];
	
	_raw.SetCallback(&default_hit_callback, (__bridge void*)self);
}




- (BOOL)isEqualToBreakpoint:(LLDBBreakpoint *)breakpoint
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(breakpoint, LLDBBreakpoint);
	
	return	_raw.operator==(breakpoint->_raw);
}
- (BOOL)isEqualTo:(id)object
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	if (self == object)
	{
		return	YES;
	}
	
	if ([object isKindOfClass:[LLDBBreakpoint class]])
	{
		return	[self isEqualToBreakpoint:object];
	}
	
	return	NO;
}
- (BOOL)isEqual:(id)object
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[self isEqualTo:object];
}
- (NSString *)description
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	get_description_of(_raw);
}
@end








