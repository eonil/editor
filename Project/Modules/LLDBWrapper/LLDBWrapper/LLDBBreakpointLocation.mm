//
//  LLDBBreakpointLocation.m
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#import "LLDBBreakpointLocation.h"
#import "LLDB_Internals.h"

@implementation LLDBBreakpointLocation
LLDBOBJECT_INIT_IMPL(lldb::SBBreakpointLocation);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}








- (BOOL)isEqualTo:(id)object
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DELETED_METHOD();
}
- (BOOL)isEqual:(id)object
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	UNIVERSE_DELETED_METHOD();
}
- (NSString *)description
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	get_description_of(_raw, lldb::DescriptionLevel::eDescriptionLevelVerbose);
}
@end
