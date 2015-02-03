//
//  LLDBThread.h
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#pragma once
#import "LLDBObject.h"
#import "LLDBDeclarations.h"
#import "LLDBEnums.h"


@interface	LLDBThread : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;



@property	(readonly,nonatomic,assign)	LLDBStopReason	stopReason;
@property	(readonly,nonatomic,assign)	size_t			stopReasonDataCount;
//--------------------------------------------------------------------------
/// Get information associated with a stop reason.
///
/// Breakpoint stop reasons will have data that consists of pairs of
/// breakpoint IDs followed by the breakpoint location IDs (they always come
/// in pairs).
///
/// Stop Reason              Count Data Type
/// ======================== ===== =========================================
/// eStopReasonNone          0
/// eStopReasonTrace         0
/// eStopReasonBreakpoint    N     duple: {breakpoint id, location id}
/// eStopReasonWatchpoint    1     watchpoint id
/// eStopReasonSignal        1     unix signal number
/// eStopReasonException     N     exception data
/// eStopReasonExec          0
/// eStopReasonPlanComplete  0
//--------------------------------------------------------------------------
- (uint64_t)stopReasonDataAtIndex:(uint32_t)index;
//- (size_t)	stopDescription:(char*)destination length:(size_t)length;
- (NSString*)stopDescription;
- (LLDBValue*)stopReturnValue;



@property	(readonly,nonatomic,assign)	LLDBThreadIDType	threadID;
@property	(readonly,nonatomic,assign)	uint32_t			indexID;
@property	(readonly,nonatomic,copy)	NSString*			name;
@property	(readonly,nonatomic,copy)	NSString*			queueName;
@property	(readonly,nonatomic,assign)	LLDBQueueIDType		queueID;



- (void)	stepOver;												///<	@c stopOtherThreads==LLDBRunModeOnlyDuringStepping\.
- (void)	stepOverWithRunMode:(LLDBRunMode)stopOtherThreads;
- (void)	stepInto;												///<	@c stopOtherThreads==LLDBRunModeOnlyDuringStepping\.
- (void)	stepIntoWithRunMode:(LLDBRunMode)stopOtherThreads;
- (void)	stepOut;
- (void)	stepOutOfFrame:(LLDBFrame*)frame;
- (void)	stepInstruction:(BOOL)stepOver;
- (LLDBError*)stepOverUntilFrame:(LLDBFrame*)frame file:(LLDBFileSpec*)fileSpec line:(uint32_t)line;
- (LLDBError*)jumpToFile:(LLDBFileSpec*)fileSpec line:(uint32_t)line;
- (void)	runToAddress:(LLDBAddressType)address;
- (LLDBError*)returnFromFrame:(LLDBFrame*)frame returnValue:(LLDBValue**)returnValue;



//--------------------------------------------------------------------------
/// LLDB currently supports process centric debugging which means when any
/// thread in a process stops, all other threads are stopped. The Suspend()
/// call here tells our process to suspend a thread and not let it run when
/// the other threads in a process are allowed to run. So when
/// SBProcess::Continue() is called, any threads that aren't suspended will
/// be allowed to run. If any of the SBThread functions for stepping are
/// called (StepOver, StepInto, StepOut, StepInstruction, RunToAddres), the
/// thread will not be allowed to run and these funtions will simply return.
///
/// Eventually we plan to add support for thread centric debugging where
/// each thread is controlled individually and each thread would broadcast
/// its state, but we haven't implemented this yet.
///
/// Likewise the SBThread::Resume() call will again allow the thread to run
/// when the process is continued.
///
/// Suspend() and Resume() functions are not currently reference counted, if
/// anyone has the need for them to be reference counted, please let us
/// know.
//--------------------------------------------------------------------------
- (BOOL)	suspend;
- (BOOL)	resume;
@property	(readonly,nonatomic,assign,getter=isSuspended)	BOOL	suspended;
@property	(readonly,nonatomic,assign,getter=isStopped)	BOOL	stopped;

@property	(readonly,nonatomic,assign)	uint32_t		numberOfFrames;
- (LLDBFrame*)frameAtIndex:(uint32_t)index;

@property	(readonly,nonatomic,strong)	LLDBProcess*	process;

//@property	(readonly,nonatomic,copy)	NSString*		status;













- (BOOL)	isEqualToThread:(LLDBThread*)object;
- (BOOL)	isEqual:(id)object;
@end
















