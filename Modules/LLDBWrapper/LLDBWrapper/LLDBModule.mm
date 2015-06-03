//
//  LLDBModule.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBModule.h"
#import "LLDB_Internals.h"

@implementation LLDBModule
LLDBOBJECT_INIT_IMPL(lldb::SBModule);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}









- (LLDBFileSpec *)fileSpec
{
	return	[[LLDBFileSpec alloc] initWithCPPObject:_raw.GetFileSpec()];
}




- (size_t)numberOfSymbols
{
	return	_raw.GetNumSymbols();
}
- (LLDBSymbol *)symbolAtIndex:(size_t)index
{
	return	[[LLDBSymbol alloc] initWithCPPObject:_raw.GetSymbolAtIndex(index)];
}

- (BOOL)isEqualToModule:(LLDBModule *)object
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(object, LLDBModule);
	
	return	self == object || _raw.operator==(object->_raw);
}
- (BOOL)isEqual:(id)object
{
	return	self == object || ([object isKindOfClass:[LLDBModule class]] && [self isEqualToModule:object]);
}



- (NSString *)description
{
	return	get_description_of(_raw);
}
@end






















