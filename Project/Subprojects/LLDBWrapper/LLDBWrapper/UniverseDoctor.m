//
//  UniverseDoctor.m
//  Spacetime
//
//  Created by Hoon H. on 14/5/26.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

#import "UniverseDoctor.h"










static NSString* const		REASON_UNKNOWN	=	@"Reason unknown";


UNIVERSE_NON_RETURNING_METHOD
static void
universe_except(NSString* message)
{
	NSString*				reason	=	[NSString stringWithFormat:@"[CANCEL/EXCEPT] %@", message];
	UniverseCancellation*	exc		=	[[UniverseCancellation alloc] initWithName:@"CANCEL/EXCEPT" reason:reason userInfo:nil];
	NSLog(@"%@", exc);
	@throw	exc;
}

UNIVERSE_NON_RETURNING_METHOD
static void
universe_panic(NSString* message)
{
	NSString*			reason	=	[NSString stringWithFormat:@"[CORRUPTION/PANIC] %@", message];
	UniverseCorruption*	exc		=	[[UniverseCorruption alloc] initWithName:@"CORRUPTION/PANIC" reason:reason userInfo:nil];
	NSLog(@"%@", exc);
	@throw	exc;
}









@implementation UniverseException
@end
@implementation UniverseCancellation
@end
@implementation UniverseCorruption
@end


@implementation UniverseDoctor
+ (void)exceptWithMessage:(NSString *)message
{
	universe_except(message);
}
+ (void)except
{
	universe_except(REASON_UNKNOWN);
}
+ (void)exceptIf:(BOOL)condition withMessage:(NSString *)message
{
	if (condition)
	{
		universe_except(message);
	}
}
+ (void)exceptIf:(BOOL)condition
{
	if (condition)
	{
		universe_except(REASON_UNKNOWN);
	}
}
+ (void)panic
{
	universe_panic(REASON_UNKNOWN);
}
+ (void)panicWithMessage:(NSString *)message
{
	universe_panic(message);
}
+ (void)panicIf:(BOOL)condition
{
	if (condition)
	{
		universe_panic(REASON_UNKNOWN);
	}
}
+ (void)panicIf:(BOOL)condition withMessage:(NSString *)message
{
	if (condition)
	{
		universe_panic(message);
	}
}
@end







