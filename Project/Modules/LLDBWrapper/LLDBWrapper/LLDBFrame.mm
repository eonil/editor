//
//  LLDBFrame.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBFrame.h"
#import	"LLDB_Internals.h"

@implementation LLDBFrame
LLDBOBJECT_INIT_IMPL(lldb::SBFrame);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}



- (uint32_t)frameID
{
	return	_raw.GetFrameID();
}
//- (LLDBSymbolContext *)symbolContext:(uint32_t)resolveScope
//{
//	auto const	r	=	_raw.GetSymbolContext(resolveScope);
//	return	[[LLDBSymbolContext alloc] initWithCPPObject:r];
//}


- (LLDBModule *)module
{
	return	[[LLDBModule alloc] initWithCPPObject:_raw.GetModule()];
}
- (LLDBCompileUnit *)compileUnit
{
	return	[[LLDBCompileUnit alloc] initWithCPPObject:_raw.GetCompileUnit()];
}
- (LLDBFunction *)function
{
	return	[[LLDBFunction alloc] initWithCPPObject:_raw.GetFunction()];
}
- (LLDBSymbol *)symbol
{
	return	[[LLDBSymbol alloc] initWithCPPObject:_raw.GetSymbol()];
}
- (LLDBBlock *)block
{
	return	[[LLDBBlock alloc] initWithCPPObject:_raw.GetBlock()];
}
- (NSString *)functionName
{
	return	fromC(_raw.GetFunctionName());
}
- (BOOL)isInlined
{
	return	_raw.IsInlined() == true;
}
- (LLDBBlock *)frameBlock
{
	return	[[LLDBBlock alloc] initWithCPPObject:_raw.GetFrameBlock()];
}
- (LLDBLineEntry *)lineEntry
{
	return	[[LLDBLineEntry alloc] initWithCPPObject:_raw.GetLineEntry()];
//	return	[LLDBLineEntry lineEntryWithMaybeCPPObject:_raw.GetLineEntry()];
}
- (LLDBThread *)thread
{
	return	[[LLDBThread alloc] initWithCPPObject:_raw.GetThread()];
}
- (NSString *)disassembly
{
	return	fromC(_raw.Disassemble());
}











- (LLDBValueList *)variablesWithArguments:(BOOL)arguments locals:(BOOL)locals statics:(BOOL)statics inScopeOnly:(BOOL)inScopeOnly
{
	auto const	r	=	_raw.GetVariables(arguments, locals, statics, inScopeOnly);
	return	[[LLDBValueList alloc] initWithCPPObject:r];
}
- (LLDBValueList *)variablesWithArguments:(BOOL)arguments locals:(BOOL)locals statics:(BOOL)statics inScopeOnly:(BOOL)inScopeOnly useDynamic:(LLDBDynamicValueType)useDynamic
{
	auto const	r	=	_raw.GetVariables(arguments, locals, statics, inScopeOnly, toCPP(useDynamic));
	return	[[LLDBValueList alloc] initWithCPPObject:r];
}





- (LLDBValueList *)registers
{
	return	[[LLDBValueList alloc] initWithCPPObject:_raw.GetRegisters()];
}




//- (LLDBValue *)watchValueWithName:(NSString *)name valueType:(LLDBValueType)valueType watchtype:(uint32_t)watchType
//{
//	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(name, NSString);
//	
//	auto const	r	=	_raw.WatchValue(name.UTF8String, toCPP(valueType), watchType);
//	return	[[LLDBValue alloc] initWithCPPObject:r];
//}
//- (LLDBValue *)watchLocationWithName:(NSString *)name valueType:(LLDBValueType)valueType watchtype:(uint32_t)watchType size:(size_t)size
//{
//	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(name, NSString);
//	
//	auto const	r	=	_raw.WatchLocation(name.UTF8String, toCPP(valueType), watchType, size);
//	return	[[LLDBValue alloc] initWithCPPObject:r];
//}


















- (BOOL)isEqualToFrame:(LLDBFrame *)frame
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(frame, LLDBFrame);
	
	return	_raw.operator==(frame->_raw) == true;
}
- (BOOL)isEqualTo:(id)object
{
	if (object == self)
	{
		return	YES;
	}
	
	if ([object isKindOfClass:[LLDBFrame class]])
	{
		return	[self isEqualToFrame:object];
	}
	else
	{
		return	NO;
	}
}
- (BOOL)isEqual:(id)object
{
	return	[self isEqualTo:object];
}
- (NSString *)description
{
	return	get_description_of(_raw);
}
@end
