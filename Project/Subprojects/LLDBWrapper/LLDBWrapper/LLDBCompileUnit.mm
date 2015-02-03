//
//  LLDBCompileUnit.m
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#import "LLDBCompileUnit.h"
#import "LLDB_Internals.h"

@implementation LLDBCompileUnit
LLDBOBJECT_INIT_IMPL(lldb::SBCompileUnit);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}





- (LLDBFileSpec *)fileSpec
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[[LLDBFileSpec alloc] initWithCPPObject:_raw.GetFileSpec()];
}
- (uint32_t)numberOfLineEntries
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetNumLineEntries();
}
- (LLDBLineEntry *)lineEntryAtIndex:(uint32_t)index
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT(index < _raw.GetNumLineEntries());
	
	return	[[LLDBLineEntry alloc] initWithCPPObject:_raw.GetLineEntryAtIndex(index)];
}
- (uint32_t)numberOfSupportFiles
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetNumSupportFiles();
}
- (LLDBFileSpec *)supportFileAtIndex:(uint32_t)index
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT(index < _raw.GetNumSupportFiles());
	
	return	[[LLDBFileSpec alloc] initWithCPPObject:_raw.GetSupportFileAtIndex(index)];
}




- (BOOL)isEqualToCompileUnit:(LLDBCompileUnit *)compileUnit
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(compileUnit, LLDBCompileUnit);
	
	return	_raw.operator==(compileUnit->_raw) == true;
}
- (BOOL)isEqualTo:(id)object
{
	if (self == object)
	{
		return	YES;
	}
	
	if ([object isKindOfClass:[LLDBCompileUnit class]])
	{
		return	[self isEqualToCompileUnit:object];
	}
	
	return	NO;
}
- (BOOL)isEqual:(id)object
{
	return	[self isEqual:object];
}




- (NSString *)description
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	get_description_of(_raw);
}
@end
