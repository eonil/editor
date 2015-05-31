//
//  LLDBModule.h
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#pragma once
#import "LLDBObject.h"
#import "LLDBDeclarations.h"

@interface LLDBModule : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;

- (LLDBFileSpec*)fileSpec;

//@property (readonly,nonatomic,assign)	NSUInteger	numberOfCompileUnits;
//- (LLDBSymbol*)compileUnitAtIndex:(NSUInteger)index;


@property (readonly,nonatomic,assign)	size_t	numberOfSymbols;
- (LLDBSymbol*)symbolAtIndex:(size_t)index;

- (BOOL)isEqualToModule:(LLDBModule*)object;
- (BOOL)isEqual:(id)object;

@end


