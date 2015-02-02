//
//  LLDBFunction.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBFunction.h"
#import "LLDB_Internals.h"

@implementation LLDBFunction
LLDBOBJECT_INIT_IMPL(lldb::SBFunction);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}






- (NSString *)name
{
	return	fromC(_raw.GetName());
}
- (NSString *)mangledName
{
	return	fromC(_raw.GetMangledName());
}
- (LLDBInstructionList *)instructionsForTarget:(LLDBTarget *)target
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(target, LLDBTarget);
	
	return	[[LLDBInstructionList alloc] initWithCPPObject:_raw.GetInstructions(target->_raw)];
}
- (LLDBInstructionList *)instructionsForTarget:(LLDBTarget *)target flavor:(NSString *)flavor
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(target, LLDBTarget);
	
	return	[[LLDBInstructionList alloc] initWithCPPObject:_raw.GetInstructions(target->_raw, flavor.UTF8String)];
}












- (LLDBAddress *)startAddress
{
	return	[[LLDBAddress alloc] initWithCPPObject:_raw.GetStartAddress()];
}
- (LLDBAddress *)endAddress
{
	return	[[LLDBAddress alloc] initWithCPPObject:_raw.GetEndAddress()];
}
- (uint32_t)prologueByteSize
{
	return	_raw.GetPrologueByteSize();
}
- (LLDBBlock *)block
{
	return	[[LLDBBlock alloc] initWithCPPObject:_raw.GetBlock()];
}










- (BOOL)isEqualToFunction:(LLDBFunction *)object
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(object, LLDBFunction);
	return	_raw.operator==(object->_raw);
}
- (BOOL)isEqualTo:(id)object
{
	if (self == object)
	{
		return	YES;
	}
	
	if ([object isKindOfClass:[LLDBFunction class]])
	{
		return	[self isEqualToFunction:object];
	}
	
	return	NO;
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








