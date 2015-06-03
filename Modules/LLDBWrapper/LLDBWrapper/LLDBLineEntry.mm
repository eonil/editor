//
//  LLDBLineEntry.m
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#import "LLDBLineEntry.h"
#import "LLDB_Internals.h"

@implementation LLDBLineEntry
LLDBOBJECT_INIT_IMPL(lldb::SBLineEntry);
+ (LLDBLineEntry *)lineEntryWithMaybeCPPObject:(lldb::SBLineEntry)maybeCPPObject
{
	if (maybeCPPObject.IsValid()) {
		return	[[LLDBLineEntry alloc] initWithCPPObject:maybeCPPObject];
	}
	return	nil;
}
- (LLDBFileSpec *)fileSpec
{
	return	[[LLDBFileSpec alloc] initWithCPPObject:_raw.GetFileSpec()];
}
- (uint32_t)line
{
	return	_raw.GetLine();
}
- (uint32_t)column
{
	return	_raw.GetColumn();
}







- (BOOL)isEqualToLineEntry:(LLDBLineEntry *)lineEntry
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(lineEntry, LLDBLineEntry);
	return	_raw == lineEntry->_raw;
}
- (BOOL)isEqualTo:(id)object
{
	if (self == object) {
		return	YES;
	}
	if ([object isKindOfClass:[LLDBLineEntry class]]) {
		return	[self isEqualToLineEntry:object];
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
