//
//  LLDBEvent.m
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#import "LLDBEvent.h"
#import "LLDB_Internals.h"

@implementation LLDBEvent
LLDBOBJECT_INIT_IMPL(lldb::SBEvent);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}
- (instancetype)initWithEvent:(uint32_t)event string:(NSString *)string
{
	auto const	data	=	[string dataUsingEncoding:NSUTF8StringEncoding];
	auto const	len		=	uint32_t([data length]);
	auto const	bytes	=	static_cast<const char*>([data bytes]);
	
	//	`SBEvent` ctor ultimately makes `std::string`, and that means content will be copied.
	return	[self initWithCPPObject:lldb::SBEvent(event, bytes, len)];
}



- (NSString *)description
{
	return	get_description_of(_raw);
}
@end
