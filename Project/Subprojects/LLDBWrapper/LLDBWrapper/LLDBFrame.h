//
//  LLDBFrame.h
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#pragma once
#import "LLDBObject.h"
#import "LLDBDeclarations.h"
#import "LLDBEnums.h"

@interface	LLDBFrame : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;




@property	(readonly,nonatomic,assign)	uint32_t		frameID;
//- (LLDBSymbolContext*)symbolContext:(uint32_t)resolveScope;
@property	(readonly,nonatomic,copy)	LLDBModule*			module;
@property	(readonly,nonatomic,copy)	LLDBCompileUnit*	compileUnit;
@property	(readonly,nonatomic,copy)	LLDBFunction*		function;
@property	(readonly,nonatomic,copy)	LLDBSymbol*			symbol;
/// Gets the deepest block that contains the frame PC.
///
/// See also GetFrameBlock().
@property	(readonly,nonatomic,copy)	LLDBBlock*			block;
/// Get the appropriate function name for this frame. Inlined functions in
/// LLDB are represented by Blocks that have inlined function information, so
/// just looking at the SBFunction or SBSymbol for a frame isn't enough.
/// This function will return the appriopriate function, symbol or inlined
/// function name for the frame.
///
/// This function returns:
/// - the name of the inlined function (if there is one)
/// - the name of the concrete function (if there is one)
/// - the name of the symbol (if there is one)
/// - NULL
///
/// See also IsInlined().
@property	(readonly,nonatomic,copy)	NSString*			functionName;
@property	(readonly,nonatomic,assign,getter=isInlined)	BOOL				inlined;

/// Gets the lexical block that defines the stack frame. Another way to think
/// of this is it will return the block that contains all of the variables
/// for a stack frame. Inlined functions are represented as SBBlock objects
/// that have inlined function information: the name of the inlined function,
/// where it was called from. The block that is returned will be the first
/// block at or above the block for the PC (SBFrame::GetBlock()) that defines
/// the scope of the frame. When a function contains no inlined functions,
/// this will be the top most lexical block that defines the function.
/// When a function has inlined functions and the PC is currently
/// in one of those inlined functions, this method will return the inlined
/// block that defines this frame. If the PC isn't currently in an inlined
/// function, the lexical block that defines the function is returned.
@property	(readonly,nonatomic,copy)	LLDBBlock*			frameBlock;
@property	(readonly,nonatomic,copy)	LLDBLineEntry*		lineEntry;			///<	Can return `nil` if frame does not have a proper line-entry information.
@property	(readonly,nonatomic,copy)	LLDBThread*			thread;

@property	(readonly,nonatomic,copy)	NSString*			disassembly;

/// The version that doesn't supply a 'use_dynamic' value will use the
/// target's default.
- (LLDBValueList*)variablesWithArguments:(BOOL)arguments locals:(BOOL)locals statics:(BOOL)statics inScopeOnly:(BOOL)inScopeOnly;
- (LLDBValueList*)variablesWithArguments:(BOOL)arguments locals:(BOOL)locals statics:(BOOL)statics inScopeOnly:(BOOL)inScopeOnly useDynamic:(LLDBDynamicValueType)useDynamic;

@property	(readonly,nonatomic,copy)	LLDBValueList*		registers;


///// Find and watch a variable using the frame as the scope.
///// It returns an SBValue, similar to FindValue() method, if find-and-watch
///// operation succeeds.  Otherwise, an invalid SBValue is returned.
///// You can use LLDB_WATCH_TYPE_READ | LLDB_WATCH_TYPE_WRITE for 'rw' watch.
//- (LLDBValue*)watchValueWithName:(NSString*)name valueType:(LLDBValueType)valueType watchtype:(uint32_t)watchType;
//
///// Find and watch the location pointed to by a variable using the frame as
///// the scope.
///// It returns an SBValue, similar to FindValue() method, if find-and-watch
///// operation succeeds.  Otherwise, an invalid SBValue is returned.
///// You can use LLDB_WATCH_TYPE_READ | LLDB_WATCH_TYPE_WRITE for 'rw' watch.
//- (LLDBValue*)watchLocationWithName:(NSString*)name valueType:(LLDBValueType)valueType watchtype:(uint32_t)watchType size:(size_t)size;





- (BOOL)	isEqualToFrame:(LLDBFrame*)frame;
- (BOOL)	isEqualTo:(id)object;
- (BOOL)	isEqual:(id)object;
@end










