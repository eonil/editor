//
//  LLDBInstructionList.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBInstructionList.h"
#import "LLDB_Internals.h"

@implementation LLDBInstructionList
LLDBOBJECT_INIT_IMPL(lldb::SBInstructionList);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}



- (size_t)size
{
	return	_raw.GetSize();
}
- (LLDBInstruction *)instructionAtIndex:(uint32_t)index
{
	return	[[LLDBInstruction alloc] initWithCPPObject:_raw.GetInstructionAtIndex(index)];
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
	return	get_description_of(_raw);
}
@end
