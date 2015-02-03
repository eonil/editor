//
//  LLDBThread.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBThread.h"
#import "LLDB_Internals.h"
#import "LLDBEnums.h"


//NSUInteger const		LLDBRunModeOnlyThisThread		=	lldb::eOnlyThisThread;
//NSUInteger const		LLDBRunModeAllThreads			=	lldb::eAllThreads;
//NSUInteger const		LLDBRunModeOnlyDuringStepping	=	lldb::eOnlyDuringStepping;
//
//static void
//assert_valid_run_mode_value(NSUInteger const value)
//{
//	switch (value)
//	{
//		case	LLDBRunModeOnlyThisThread:		return;
//		case	LLDBRunModeAllThreads:			return;
//		case	LLDBRunModeOnlyDuringStepping:	return;
//		default:
//		{
//			UNIVERSE_DEBUG_ASSERT(NO);
//		}
//	}
//}



@implementation LLDBThread
LLDBOBJECT_INIT_IMPL(lldb::SBThread);
+ (LLDBThread *)threadWithMaybeCPPObject:(lldb::SBThread)raw
{
	if (raw.IsValid())
	{
		return	nil;
	}
	else
	{
		return	[[LLDBThread alloc] initWithCPPObject:raw];
	}
}
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}








- (LLDBStopReason)stopReason
{
	return	fromCPP(_raw.GetStopReason());
}
- (size_t)stopReasonDataCount
{
	return	_raw.GetStopReasonDataCount();
}
- (uint64_t)stopReasonDataAtIndex:(uint32_t)index
{
	return	_raw.GetStopReasonDataAtIndex(index);
}
- (NSString *)stopDescription
{
	//	Passing `nullptr` will provide exact length including terminating NULL byte.
	//	https://github.com/ice799/lldb/blob/master/source/API/SBThread.cpp#L83
	//
	//	This function is fundamentally inefficient, and there's no way t avoid it.

	auto const	len		=	_raw.GetStopDescription(nullptr, 0);
	char		buf[len];
	auto const	len1	=	_raw.GetStopDescription(buf, len);
	assert(buf[len-1] == 0);
	assert(len1 == 0 || len1 + 1 == len);
	
	return	fromC(buf);
}
- (LLDBValue *)stopReturnValue
{
	return	[[LLDBValue alloc] initWithCPPObject:_raw.GetStopReturnValue()];
}






- (LLDBThreadIDType)threadID
{
	return	_raw.GetThreadID();
}
- (uint32_t)indexID
{
	return	_raw.GetIndexID();
}
- (NSString *)name
{
	return	fromC(_raw.GetName());
}
- (NSString *)queueName
{
	return	fromC(_raw.GetQueueName());
}
- (LLDBQueueIDType)queueID
{
	return	_raw.GetQueueID();
}









- (void)stepOver
{
	[self stepOverWithRunMode:(LLDBRunModeOnlyDuringStepping)];
}
- (void)stepOverWithRunMode:(LLDBRunMode)stopOtherThreads
{
//	assert_valid_run_mode_value(stopOtherThreads);
	_raw.StepOver((lldb::RunMode)stopOtherThreads);
}
- (void)stepInto
{
	[self stepIntoWithRunMode:(LLDBRunModeOnlyDuringStepping)];
}
- (void)stepIntoWithRunMode:(LLDBRunMode)stopOtherThreads
{
//	assert_valid_run_mode_value(stopOtherThreads);
	_raw.StepInto((lldb::RunMode)stopOtherThreads);
}
- (void)stepOut
{
	_raw.StepOut();
}
- (void)stepOutOfFrame:(LLDBFrame *)frame
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(frame, LLDBFrame);
	
	////
	
	_raw.StepOutOfFrame(frame->_raw);
}
- (void)stepInstruction:(BOOL)stepOver
{
	_raw.StepInstruction(stepOver ? true : false);
}
- (LLDBError *)stepOverUntilFrame:(LLDBFrame *)frame file:(LLDBFileSpec *)fileSpec line:(uint32_t)line
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(frame, LLDBFrame);
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(fileSpec, LLDBFileSpec);
	
	auto const	r	=	_raw.StepOverUntil(frame->_raw, fileSpec->_raw, line);
	return	[[LLDBError alloc] initWithCPPObject:r];
}
- (LLDBError *)jumpToFile:(LLDBFileSpec *)fileSpec line:(uint32_t)line
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(fileSpec, LLDBFileSpec);
	
	auto const	r	=	_raw.JumpToLine(fileSpec->_raw, line);
	return	[[LLDBError alloc] initWithCPPObject:r];
}
- (void)runToAddress:(LLDBAddressType)address
{
	_raw.RunToAddress(address);
}
- (LLDBError *)returnFromFrame:(LLDBFrame *)frame returnValue:(LLDBValue *__autoreleasing *)returnValue
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(frame, LLDBFrame);
	UNIVERSE_DEBUG_ASSERT(returnValue != nullptr);
	
	lldb::SBValue	rv;
	auto const	e	=	_raw.ReturnFromFrame(frame->_raw, rv);
	*returnValue	=	[[LLDBValue alloc] initWithCPPObject:rv];
	return	[[LLDBError alloc] initWithCPPObject:e];
}






- (BOOL)suspend
{
	return	_raw.Suspend() == true;
}
- (BOOL)resume
{
	return	_raw.Resume() == true;
}
- (BOOL)isSuspended
{
	return	_raw.IsSuspended() == true;
}
- (BOOL)isStopped
{
	return	_raw.IsSuspended() == true;
}





- (uint32_t)numberOfFrames
{
	return	_raw.GetNumFrames();
}
- (LLDBFrame *)frameAtIndex:(uint32_t)index
{
	UNIVERSE_DEBUG_ASSERT(index < _raw.GetNumFrames());
	
	return	[[LLDBFrame alloc] initWithCPPObject:_raw.GetFrameAtIndex(index)];
}

- (LLDBProcess *)process
{
	return	[[LLDBProcess alloc] initWithCPPObject:_raw.GetProcess()];
}



























- (BOOL)isEqualToThread:(LLDBThread *)object
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(object, LLDBThread);
	
	return	self == object || _raw.operator==(object->_raw) == true;
}
- (BOOL)isEqual:(id)object
{
	return	object == self || ([object isKindOfClass:[LLDBThread class]] && [self isEqualToThread:object]);
}
- (NSString *)description
{
	return	get_description_of(_raw);
}
@end

