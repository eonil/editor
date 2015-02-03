//
//  LLDBTarget.h
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/6/14.
//
//

#pragma once
#import	"LLDBObject.h"
#import "LLDBDeclarations.h"





@interface	LLDBTarget : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;

@property	(readonly,nonatomic,copy)	LLDBProcess*		process;

- (LLDBFileSpec*)executableFileSpec;

- (LLDBBreakpoint*)createBreakpointByLocationWithFileSpec:(LLDBFileSpec*)fileSpec lineNumber:(uint32_t)lineNumber;
- (LLDBBreakpoint*)createBreakpointByName:(NSString*)symbolName;
- (LLDBBreakpoint*)createBreakpointByName:(NSString*)symbolName moduleName:(NSString*)moduleName;
- (LLDBProcess*)launchProcessSimplyWithWorkingDirectory:(NSString*)workingDirectory;
//- (LLDBProcess*)instantiateProcessByLaunchingSimplyWithArguments:(NSArray*)arguments environments:(NSArray*)environments workingDirectory:(NSString*)workingDirectory;
- (LLDBProcess*)attachToProcessWithID:(uint64_t)pid error:(LLDBError**)error;		///<	`error` parameter cannot be `nil`.

@property	(readonly,nonatomic,assign)	uint32_t			numberOfModules;
- (LLDBModule*)moduleAtIndex:(uint32_t)index;
- (LLDBModule*)findModule:(LLDBFileSpec*)fileSpec;

- (NSString*)triple;

@property	(readonly,nonatomic,assign)	uint32_t			numberOfBreakpoints;
- (LLDBBreakpoint*)breakpointAtIndex:(uint32_t)index;






@property	(readonly,nonatomic,copy)	LLDBBroadcaster*	broadcaster;



- (BOOL)	isEqualToTarget:(LLDBTarget*)object;
- (BOOL)	isEqual:(id)object;
@end
//
//@interface	LLDBTarget (LLDBObjectiveCLayerExtensions)
//- (NSArray*)allModules;
//- (NSArray*)allBreakpoints;
//@end










