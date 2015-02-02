//
//  LLDBWatchpoint.m
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#import "LLDBWatchpoint.h"
#import "LLDB_Internals.h"

@implementation LLDBWatchpoint
LLDBOBJECT_INIT_IMPL(lldb::SBWatchpoint);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}






- (LLDBError *)error
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	[[LLDBError alloc] initWithCPPObject:_raw.GetError()];
}
- (LLDBWatchIDType)ID
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetID();
}




- (int32_t)hardwareIndex
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetHardwareIndex();
}
- (LLDBAddressType)watchAddress
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetWatchAddress();
}
- (size_t)watchSize
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetWatchSize();
}









- (BOOL)isEnabled
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.IsEnabled() == true;
}
- (void)setEnabled:(BOOL)enabled
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetEnabled(enabled == YES);
}


- (uint32_t)hitCount
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetHitCount();
}
- (uint32_t)ignoreCount
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	_raw.GetIgnoreCount();
}
- (void)setIgnoreCount:(uint32_t)ignoreCount
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetIgnoreCount(ignoreCount);
}
- (NSString *)condition
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	fromC(_raw.GetCondition());
}
- (void)setCondition:(NSString *)condition
{
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	_raw.SetCondition(condition.UTF8String);
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
	UNIVERSE_DEBUG_ASSERT(_raw.IsValid());
	
	return	get_description_of(_raw, lldb::DescriptionLevel::eDescriptionLevelVerbose);
}

@end
