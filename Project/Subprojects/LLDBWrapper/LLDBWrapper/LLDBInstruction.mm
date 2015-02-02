//
//  LLDBInstruction.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBInstruction.h"
#import "LLDB_Internals.h"

@implementation LLDBInstruction
LLDBOBJECT_INIT_IMPL(lldb::SBInstruction);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}






- (NSString *)mnemonicForTarget:(LLDBTarget *)target
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(target, LLDBTarget);
	
	////
	
	return	fromC(_raw.GetMnemonic(target->_raw));
}
- (NSString *)operandsForTarget:(LLDBTarget *)target
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(target, LLDBTarget);
	
	////
	
	return	fromC(_raw.GetOperands(target->_raw));
}
- (NSString *)commentForTarget:(LLDBTarget *)target
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(target, LLDBTarget);
	
	////
	
	return	fromC(_raw.GetComment(target->_raw));
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
