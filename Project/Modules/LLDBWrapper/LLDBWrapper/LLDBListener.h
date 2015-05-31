//
//  LLDBListener.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#pragma once
#import "LLDBObject.h"
#import "LLDBDeclarations.h"

@interface LLDBListener : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;
- (instancetype)initWithName:(NSString*)name;

//- (void)	addEvent:(LLDBEvent*)event;
//
//- (uint32_t)startListeningForEventClass:(LLDBDebugger*)debugger broadcasterClass:(NSString*)broadcasterClass eventMask:(uint32_t)eventMask;
//- (BOOL)	stopListeningForEventClass:(LLDBDebugger*)debugger broadcasterClass:(NSString*)broadcasterClass eventMask:(uint32_t)eventMask;
//
//- (uint32_t)startListeningForEvents:(LLDBDebugger*)debugger broadcasterClass:(NSString*)broadcasterClass eventMask:(uint32_t)eventMask;
//- (BOOL)	stopListeningForEvents:(LLDBDebugger*)debugger broadcasterClass:(NSString*)broadcasterClass eventMask:(uint32_t)eventMask;
//
- (BOOL)	waitForEvent:(uint32_t)numSeconds event:(LLDBEvent**)event;
//- (BOOL)	waitForEventForBroadcasterWithType:(uint32_t)numSeconds broadcaster:(LLDBBroadcaster*)broadcaster eventTypeMask:(uint32_t)eventTypeMask event:(LLDBEvent*)event;
//
//- (BOOL)	peekAtNextEvent:(LLDBEvent*)event;
//- (BOOL)	peekAtNextEventForBroadcaster:(LLDBBroadcaster*)broadcaster event:(LLDBEvent*)event;
//- (BOOL)	peekAtNextEventForBroadcasterWithType:(LLDBBroadcaster*)broadcaster eventTypeMask:(uint32_t)eventTypeMask event:(LLDBEvent*)event;
//
//- (BOOL)	nextEvent:(LLDBEvent*)event;
//- (BOOL)	nextEventForBroadcaster:(LLDBBroadcaster*)broadcaster event:(LLDBEvent*)event;
//- (BOOL)	nextEventForBroadcasterWithType:(LLDBBroadcaster*)broadcaster eventTypeMask:(uint32_t)eventTypeMask event:(LLDBEvent*)event;
//
//- (BOOL)	handleBroadcastEvent:(LLDBEvent*)event;





- (BOOL)	isEqual:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)	isEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (NSString *)description UNIVERSE_UNAVAILABLE_METHOD;
@end
