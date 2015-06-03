//
//  LLDBFileHandle.m
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/02/02.
//
//

#import "LLDBFileHandle.h"
#import "LLDB_Internals.h"

@implementation LLDBFileHandle
- (instancetype)initWithCObject:(FILE *)raw
{
	UNIVERSE_DEBUG_ASSERT(raw != NULL);
	
	if (self = [super init])
	{
		_raw	=	raw;
	}
	return	self;
}
- (void)dealloc
{
	auto const	r	=	fclose(_raw);
	UNIVERSE_DEBUG_ASSERT(r == 0);
}



- (FILE *)fileStreamHandle
{
	return	_raw;
}
- (int)fileDescriptor
{
	return	fileno(_raw);
}



- (void)flush
{
	auto const	r	=	fflush(_raw);
	UNIVERSE_DEBUG_ASSERT(r == 0);
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
