//
//  LLDBEvent.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#pragma once
#import "LLDBObject.h"
#import "LLDBDeclarations.h"

@interface LLDBEvent : LLDBObject
//- (instancetype)initWithEvent:(uint32_t)event cString:(char const*)cString length:(uint32_t)length;

/*!
 This internally copies supplied string.
 */
- (instancetype)initWithEvent:(uint32_t)event string:(NSString*)string;

@property	(readonly,nonatomic,copy)	NSString*			dataFlavor;
@property	(readonly,nonatomic,assign)	uint32_t			type;
@property	(readonly,nonatomic,copy)	LLDBBroadcaster*	broadcaster;
@property	(readonly,nonatomic,copy)	NSString*			broadcasterClass;

//- (BOOL)	broadcasterMatchesPointer:(LLDBBroadcaster*)broadcaster;
//- (BOOL)	broadcasterMatchesReference:(LLDBBroadcaster*)broadcaster;

//+ (NSString*)stringFromEvent:(LLDBEvent*)event;

@end
