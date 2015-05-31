//
//  LLDBLineEntry.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#pragma once
#import	"LLDBObject.h"
#import "LLDBDeclarations.h"

@interface	LLDBLineEntry : LLDBObject

@property	(readonly,nonatomic,copy)		LLDBFileSpec*	fileSpec;
@property	(readonly,nonatomic,assign)		uint32_t		line;
@property	(readonly,nonatomic,assign)		uint32_t		column;

@property	(readonly,nonatomic,copy)		LLDBAddress*	startAddress;
@property	(readonly,nonatomic,copy)		LLDBAddress*	endAddress;

- (BOOL)isEqualToLineEntry:(LLDBLineEntry*)lineEntry;
- (BOOL)isEqualTo:(id)object;
- (BOOL)isEqual:(id)object;
@end
