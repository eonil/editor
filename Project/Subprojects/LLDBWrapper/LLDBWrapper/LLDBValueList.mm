//
//  LLDBValueList.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBValueList.h"
#import "LLDB_Internals.h"

@implementation LLDBValueList
LLDBOBJECT_INIT_IMPL(lldb::SBValueList);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}










- (uint32_t)size
{
	return	_raw.GetSize();
}
- (LLDBValue *)valueAtIndex:(uint32_t)index
{
	UNIVERSE_DEBUG_ASSERT(index < _raw.GetSize());
	
	return	[[LLDBValue alloc] initWithCPPObject:_raw.GetValueAtIndex(index)];
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
	UNIVERSE_DELETED_METHOD();
}
@end
