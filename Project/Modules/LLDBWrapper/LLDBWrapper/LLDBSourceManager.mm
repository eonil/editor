//
//  LLDBSourceManager.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBSourceManager.h"
#import "LLDB_Internals.h"

@implementation LLDBSourceManager
- (instancetype)initWithCPPObject:(lldb::SBSourceManager)rawptr
{
	if (self = [super init]) {
		_rawptr		=	new lldb::SBSourceManager(rawptr);
	}
	return	self;
}
- (void)dealloc
{
	delete	_rawptr;
}



- (BOOL)isEqualTo:(id)object
{
	UNIVERSE_DELETED_METHOD();
}
- (BOOL)isEqual:(id)object
{
	UNIVERSE_DELETED_METHOD();
}
@end
