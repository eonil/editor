//
//  LLDBFileSpec.h
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/6/14.
//
//

#pragma once
#import	"LLDBObject.h"
#import "LLDBDeclarations.h"

@interface	LLDBFileSpec : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;
- (instancetype)initWithPath:(NSString*)path resolve:(BOOL)resolve;
//
//@property	(readonly,nonatomic,assign)	BOOL		exists;
//
//- (BOOL)	resolveExecutableLocation;

@property	(readonly,nonatomic,copy)	NSString*	filename;
@property	(readonly,nonatomic,copy)	NSString*	directory;
//@property	(readonly,nonatomic,copy)	NSString*	path;



- (BOOL)isEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isEqual:(id)object UNIVERSE_UNAVAILABLE_METHOD;
@end
