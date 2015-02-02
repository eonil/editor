//
//  BasicObject.m
//  LLDBWrapepr
//
//  Created by Hoon H. on 2015/01/19.
//
//

#import "BasicObject.h"

@implementation BasicObject
#if EONIL_DEBUG_MODE
{
	BOOL	_first_init_done;
}
- (id)init
{
	UNIVERSE_DEBUG_ASSERT(_first_init_done == NO);
	
	self	=	[super init];
	if (self)
	{
		_first_init_done	=	YES;
	}
	return	self;
}
#endif
@end