//
//  LLDBBroadcaster.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#pragma once
#import "LLDBObject.h"
#import "LLDBDeclarations.h"

/*!
 Eonil: This seems to be an analogue to Cocoa target-action mechanism.
 */
@interface LLDBBroadcaster : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;
- (instancetype)initWithName:(NSString*)name;

//- (void)	broadcastEventByType:(uint32_t)eventType unique:(BOOL)unique;
//- (void)	broadcastEvent:(LLDBEvent*)event unique:(BOOL)unique;
//
//- (void)	addInitialEventsToListener:(LLDBListener*)listener requestedEvents:(uint32_t)requestedEvents;
//- (uint32_t)addListener:(LLDBListener*)listener eventMask:(uint32_t)eventMask;
//
//@property	(readonly,nonatomic,copy)	NSString*	name;
//
//- (BOOL)	eventTypeHasListeners:(uint32_t)eventType;
//- (BOOL)	removeListener:(LLDBListener*)listener eventMask:(uint32_t)eventMask;
//
//
//
///*!
// Defines sort order of broadcaster object.
// */
//- (BOOL)	isLessThanBroadcaster:(LLDBBroadcaster*)broadcaster;
//- (BOOL)	isLessThan:(id)object;
//
//- (BOOL)	isLessThanOrEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
//- (BOOL)	isGreaterThan:(id)object UNIVERSE_UNAVAILABLE_METHOD;
//- (BOOL)	isGreaterThanOrEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;


/*!
 Performs identity comparison.
 */
- (BOOL)	isEqualToBroadcaster:(LLDBBroadcaster*)broadcaster;
- (BOOL)	isEqual:(id)object;

- (NSString *)description UNIVERSE_UNAVAILABLE_METHOD;
@end
