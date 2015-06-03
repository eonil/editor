//
//  LLDBBreakpoint.h
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/6/14.
//
//

#pragma once
#import	"LLDBObject.h"
#import "LLDBDeclarations.h"

typedef BOOL(^LLDBBreakpointHitCallback)(LLDBProcess* process, LLDBThread* thread, LLDBBreakpointLocation* location);


@interface	LLDBBreakpoint : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;

@property	(readwrite,nonatomic,assign)	LLDBBreakpointIDType	ID;

@property	(readwrite,nonatomic,assign,getter = isEnabled)		BOOL	enabled;
@property	(readwrite,nonatomic,assign,getter = isOntShot)		BOOL	oneShot;
@property	(readonly,nonatomic,assign,getter = isOnternal)		BOOL	internal;

@property	(readonly,nonatomic,assign)		uint32_t				hitCount;
@property	(readwrite,nonatomic,assign)	uint32_t				ignoreCount;
@property	(readwrite,nonatomic,copy)		NSString*				condition;
@property	(readwrite,nonatomic,assign)	LLDBThreadIDType		threadID;
@property	(readwrite,nonatomic,assign)	uint32_t				threadIndex;
@property	(readwrite,nonatomic,copy)		NSString*				threadName;
@property	(readwrite,nonatomic,copy)		NSString*				queueName;

@property	(readwrite,nonatomic,copy)		LLDBBreakpointHitCallback	callback;

@property	(readonly,nonatomic,assign)		size_t					numberOfResolvedLocations;
@property	(readonly,nonatomic,assign)		size_t					numberOfLocations;


- (BOOL)isEqualToBreakpoint:(LLDBBreakpoint*)breakpoint;
- (BOOL)isEqualTo:(id)object;
- (BOOL)isEqual:(id)object;

@end
