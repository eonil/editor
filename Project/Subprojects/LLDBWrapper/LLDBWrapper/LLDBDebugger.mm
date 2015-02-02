//
//  LLDBDebugger.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 14/8/17.
//
//

#import "LLDBDebugger.h"

#include <atomic>
#import <LLDB/LLDB.h>
#import "LLDB_Internals.h"

using namespace lldb;








static std::atomic_int		num_live_debugger(0);




NSString* const	LLDBArchDefault			=	[NSString stringWithUTF8String:LLDB_ARCH_DEFAULT];
NSString* const	LLDBArchDefault32Bit	=	[NSString stringWithUTF8String:LLDB_ARCH_DEFAULT_32BIT];
NSString* const	LLDBArchDefault64Bit	=	[NSString stringWithUTF8String:LLDB_ARCH_DEFAULT_64BIT];






//class FileHandleBridge {
//public:
//	FileHandleBridge() {
//	}
//	FileHandleBridge(NSFileHandle* cocoa) : _cocoa(cocoa)
//	{
//		UNIVERSE_DEBUG_ASSERT(_cocoa != NULL);
//		_cstream	=	fdopen(_cocoa.fileDescriptor, "rw");
//		UNIVERSE_DEBUG_ASSERT(_cstream != NULL);
//	}
//	
//	auto
//	getCFileStreamHandle() -> FILE*
//	{
//		return	_cstream;
//	}
//	
//private:
//	~FileHandleBridge()
//	{
//		UNIVERSE_DEBUG_ASSERT(_cocoa != NULL);
//		UNIVERSE_DEBUG_ASSERT(_cstream != NULL);
//		auto const	r	=	fclose(_cstream);
//		UNIVERSE_DEBUG_ASSERT(r == 0);
//	}
//	NSFileHandle*	_cocoa		=	nil;
//	FILE*			_cstream	=	NULL;
//};













@implementation LLDBDebugger
{
	@private
	LLDBSourceManager*	_srcmgr;

//	FILE*	_inputFH;
//	FILE*	_outputFH;
//	FILE*	_errorFH;
}





LLDBOBJECT_INIT_IMPL(lldb::SBDebugger);
- (instancetype)init
{
	self	=	[super init];
	if (self) {
		if (num_live_debugger == 0) {
			SBDebugger::Initialize();
		}
		num_live_debugger++;
		
		////
	
		_raw	=	SBDebugger::Create();
		_srcmgr	=	[[LLDBSourceManager alloc] initWithCPPObject:_raw.GetSourceManager()];
		
//		_inputFH	=	NULL;
//		_outputFH	=	NULL;
//		_errorFH	=	NULL;
	}
	return	self;
}
- (void)dealloc
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	SBDebugger::Destroy(_raw);
	
//	if (_inputFH != NULL) {
//		auto const	r	=	fclose(_inputFH);
//		_inputFH		=	NULL;
//		UNIVERSE_DEBUG_ASSERT(r == 0);
//	}
//	
//	if (_outputFH != NULL) {
//		auto const	r	=	fclose(_outputFH);
//		_outputFH		=	NULL;
//		UNIVERSE_DEBUG_ASSERT(r == 0);
//	}
//	
//	if (_errorFH != NULL) {
//		auto const	r	=	fclose(_errorFH);
//		_errorFH		=	NULL;
//		UNIVERSE_DEBUG_ASSERT(r == 0);
//	}
	
	////
	
	num_live_debugger--;
	if (num_live_debugger == 0) {
		SBDebugger::Terminate();
	}
	UNIVERSE_DEBUG_ASSERT(num_live_debugger >= 0);
}



- (BOOL)async
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetAsync() ? YES : NO;
}
- (void)setAsync:(BOOL)async
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetAsync(async ? true : false);
}

- (NSString *)stringOfState:(LLDBStateType)state
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	fromC(_raw.StateAsCString(toCPP(state)));
}








- (LLDBTarget *)createTargetWithFilename:(NSString *)filename
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[[LLDBTarget alloc] initWithCPPObject:_raw.CreateTarget(filename.UTF8String)];
}
- (LLDBTarget *)createTargetWithFilename:(NSString *)filename andArchname:(NSString *)archname
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[[LLDBTarget alloc] initWithCPPObject:_raw.CreateTargetWithFileAndArch(filename.UTF8String, archname.UTF8String)];
}


- (void)deleteTarget:(LLDBTarget *)target
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	auto const	r	=	_raw.DeleteTarget(target->_raw);
	UNIVERSE_DEBUG_ASSERT(r == true);
}







//- (FILE *)outputFileHandle
//{
//	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
//	
//	return	_raw.GetOutputFileHandle();
//}
//- (void)setOutputFileHandle:(FILE *)outputFileHandle
//{
//	[self setOutputFileHandle:outputFileHandle transferOwnership:NO];
//}
//- (void)setOutputFileHandle:(FILE *)outputFileHandle transferOwnership:(BOOL)transferOwnership
//{
//	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
//	
//	_raw.SetOutputFileHandle(outputFileHandle, transferOwnership == true);
//}
//
//- (void)setOutputFileHandle:(LLDBFileHandle *)outputFileHandle
//{
//	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
//	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE_OR_NIL(outputFileHandle, LLDBFileHandle);
//	
//	_outputFileHandle	=	outputFileHandle;
//	_raw.SetOutputFileHandle([outputFileHandle fileStreamHandle], false);
//}







- (uint32_t)numberOfTargets
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetNumTargets();
}
- (LLDBTarget *)targetAtIndex:(uint32_t)index
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT(index < _raw.GetNumTargets());
	
	return	[[LLDBTarget alloc] initWithCPPObject:_raw.GetTargetAtIndex(index)];
}

- (LLDBSourceManager *)sourceManager
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	LLDBSourceManager*	m1	=	[[LLDBSourceManager alloc] initWithCPPObject:_raw.GetSourceManager()];
	return	m1;
}








- (NSString *)description
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	get_description_of(_raw);
}
@end








