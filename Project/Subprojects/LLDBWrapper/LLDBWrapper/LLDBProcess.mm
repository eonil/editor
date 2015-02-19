//
//  LLDBProcess.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBProcess.h"
#import "LLDB_Internals.h"




@implementation LLDBProcess
LLDBOBJECT_INIT_IMPL(lldb::SBProcess)
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}








- (LLDBTarget *)target
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[[LLDBTarget alloc] initWithCPPObject:_raw.GetTarget()];
}




- (size_t)putStandardInput:(const char *)source length:(size_t)length
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.PutSTDIN(source, length);
}
- (size_t)getStandardOutput:(char *)destination length:(size_t)length
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetSTDOUT(destination, length);
}
- (size_t)getStandardError:(char *)destination length:(size_t)length
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetSTDERR(destination, length);
}







- (NSUInteger)numberOfThreads
{
	return	_raw.GetNumThreads();
}
- (LLDBThread *)threadAtIndex:(NSUInteger)index
{
	UNIVERSE_DEBUG_ASSERT(index < [self numberOfThreads]);
	
	////
	
	return	[[LLDBThread alloc] initWithCPPObject:_raw.GetThreadAtIndex(index)];
}
//- (LLDBThread *)threadByID:(LLDBThreadIDType)threadID
//{
//	return	[LLDBThread threadWithMaybeCPPObject:_raw.GetThreadByID(threadID)];
//}
//- (LLDBThread *)threadByIndexID:(uint32_t)indexID
//{
//	return	[LLDBThread threadWithMaybeCPPObject:_raw.GetThreadByIndexID(indexID)];
//}
- (LLDBThread *)selectedThread
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[LLDBThread threadWithMaybeCPPObject:_raw.GetSelectedThread()];
}
- (BOOL)setSelectedThread:(LLDBThread *)selectedThread
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.SetSelectedThread(selectedThread->_raw) == true;
}






- (LLDBStateType)state
{
//	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	fromCPP(_raw.GetState());
}
- (int)exitStatus
{
//	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetExitStatus();
}
- (NSString *)exitDescription
{
//	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	fromC(_raw.GetExitDescription());
}






- (LLDBProcessIDType)processID
{
//	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetProcessID();
}
- (uint32_t)uniqueID
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetUniqueID();
}


- (uint32_t)addressByteSize
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetAddressByteSize();
}











- (LLDBError *)destroy
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[[LLDBError alloc] initWithCPPObject:_raw.Destroy()];
}
- (LLDBError *)continue
{
	return	[[LLDBError alloc] initWithCPPObject:_raw.Continue()];
}
- (LLDBError *)stop
{
	return	[[LLDBError alloc] initWithCPPObject:_raw.Stop()];
}
- (LLDBError *)kill
{
	return	[[LLDBError alloc] initWithCPPObject:_raw.Kill()];
}
- (LLDBError *)detach
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[[LLDBError alloc] initWithCPPObject:_raw.Detach()];
}
- (LLDBError *)detach:(BOOL)keepStopped
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[[LLDBError alloc] initWithCPPObject:_raw.Detach(keepStopped)];
}
- (LLDBError *)signal:(int)signal
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[[LLDBError alloc] initWithCPPObject:_raw.Signal(signal)];
}


- (void)sendAsynchronousInterrupt
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SendAsyncInterrupt();
}
- (uint32_t)stopID:(BOOL)includeExpressionStops
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetStopID(includeExpressionStops == true);
}
- (uint32_t)stopID
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[self stopID:NO];
}






- (size_t)readMemory:(LLDBAddressType)address buffer:(void *)buffer size:(size_t)size error:(LLDBError *__autoreleasing *)error
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT(error != nullptr);
	
	lldb::SBError	e;
	auto const		r	=	_raw.ReadMemory(address, buffer, size, e);
	*error				=	[[LLDBError alloc] initWithCPPObject:e];
	return	r;
}
- (size_t)writeMemory:(LLDBAddressType)address buffer:(const void *)buffer size:(size_t)size error:(LLDBError *__autoreleasing *)error
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT(error != nullptr);
	
	lldb::SBError	e;
	auto const		r	=	_raw.WriteMemory(address, buffer, size, e);
	*error				=	[[LLDBError alloc] initWithCPPObject:e];
	return	r;
}




+ (LLDBStateType)stateFromEvent:(LLDBEvent *)event
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(event, LLDBEvent);
	
	auto const	r	=	lldb::SBProcess::GetStateFromEvent(event->_raw);
	auto const	r1	=	fromCPP(r);
	return		r1;
}
+ (BOOL)restartedFromEvent:(LLDBEvent *)event
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(event, LLDBEvent);
	
	return	lldb::SBProcess::GetRestartedFromEvent(event->_raw) == true;
}
+ (size_t)numberOfRestartedReasonsFromEvent:(LLDBEvent *)event
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(event, LLDBEvent);
	
	return	lldb::SBProcess::GetNumRestartedReasonsFromEvent(event->_raw);
}
+ (NSString *)restartedReasonAtIndexFromEvent:(LLDBEvent *)event index:(size_t)index
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(event, LLDBEvent);
	
	return	fromC(lldb::SBProcess::GetRestartedReasonAtIndexFromEvent(event->_raw, index));
}





- (uint32_t)numberOfSupportedHardwareWatchpoints:(LLDBError *__autoreleasing *)error
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT(error != nil);
	
	lldb::SBError	e;
	auto const		r	=	_raw.GetNumSupportedHardwareWatchpoints(e);
	*error				=	[[LLDBError alloc] initWithCPPObject:e];
	return	r;
}
- (uint32_t)loadImage:(LLDBFileSpec *)imageSpec error:(LLDBError *__autoreleasing *)error
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(imageSpec, LLDBFileSpec);
	UNIVERSE_DEBUG_ASSERT(error != nil);
	
	lldb::SBError	e;
	auto const		r	=	_raw.LoadImage(imageSpec->_raw, e);
	*error				=	[[LLDBError alloc] initWithCPPObject:e];
	return	r;
}
- (LLDBError *)unloadImage:(uint32_t)imageToken
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[[LLDBError alloc] initWithCPPObject:_raw.UnloadImage(imageToken)];
}










- (uint32_t)numberOfExtendedBacktraceTypes
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetNumExtendedBacktraceTypes();
}
- (NSString *)extendedBacktraceTypeAtIndex:(uint32_t)index
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	fromC(_raw.GetExtendedBacktraceTypeAtIndex(index));
}




















- (LLDBBroadcaster *)broadcaster
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[[LLDBBroadcaster alloc] initWithCPPObject:_raw.GetBroadcaster()];
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
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	get_description_of(_raw);
}
@end









