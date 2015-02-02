//
//  LLDBCompileUnit.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#pragma once
#import	"LLDBObject.h"
#import "LLDBDeclarations.h"

@interface LLDBCompileUnit : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;

@property	(readonly,nonatomic,copy)	LLDBFileSpec*		fileSpec;
@property	(readonly,nonatomic,assign)	uint32_t			numberOfLineEntries;
- (LLDBLineEntry*)lineEntryAtIndex:(uint32_t)index;

- (LLDBFileSpec*)supportFileAtIndex:(uint32_t)index;
@property	(readonly,nonatomic,assign)	uint32_t			numberOfSupportFiles;

- (BOOL)isEqualToCompileUnit:(LLDBCompileUnit*)compileUnit;
- (BOOL)isEqualTo:(id)object;
- (BOOL)isEqual:(id)object;
@end
