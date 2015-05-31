//
//  LLDBListener.m
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#import "LLDBListener.h"
#import "LLDB_Internals.h"

@implementation LLDBListener
LLDBOBJECT_INIT_IMPL(lldb::SBListener)
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}

- (instancetype)initWithName:(NSString *)name
{
	return	[self initWithCPPObject:lldb::SBListener([name cStringUsingEncoding:NSUTF8StringEncoding])];
}













- (void)addEvent:(LLDBEvent *)event
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(event, LLDBEvent);
	
	_raw.AddEvent(event->_raw);
}









- (BOOL)waitForEvent:(uint32_t)numSeconds event:(LLDBEvent *__autoreleasing *)event
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());

	lldb::SBEvent	e{};
	auto const		r	=	_raw.WaitForEvent(numSeconds, e);
	*event				=	[[LLDBEvent alloc] initWithCPPObject:e];
	return	r;
}








- (BOOL)peekAtNextEvent:(LLDBEvent *)event
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(event, LLDBEvent);
	
	return	_raw.PeekAtNextEvent(event->_raw) == true;
}
- (BOOL)peekAtNextEventForBroadcaster:(LLDBBroadcaster *)broadcaster event:(LLDBEvent *)event
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(broadcaster, LLDBBroadcaster);
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(event, LLDBEvent);
	
	return	_raw.PeekAtNextEventForBroadcaster(broadcaster->_raw, event->_raw) == true;
}
- (BOOL)peekAtNextEventForBroadcasterWithType:(LLDBBroadcaster *)broadcaster eventTypeMask:(uint32_t)eventTypeMask event:(LLDBEvent *)event
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(broadcaster, LLDBBroadcaster);
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(event, LLDBEvent);
	
	return	_raw.PeekAtNextEventForBroadcasterWithType(broadcaster->_raw, eventTypeMask, event->_raw) == true;
}

- (uint32_t)startListeningForEventClass:(LLDBDebugger *)debugger broadcasterClass:(NSString *)broadcasterClass eventMask:(uint32_t)eventMask
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(debugger, LLDBDebugger);
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(broadcasterClass, NSString);
	
	return	_raw.StartListeningForEventClass(debugger->_raw, broadcasterClass.UTF8String, eventMask);
}


- (NSString *)description
{
	UNIVERSE_DELETED_METHOD();
}
@end
