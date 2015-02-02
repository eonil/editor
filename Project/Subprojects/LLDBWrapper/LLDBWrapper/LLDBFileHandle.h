//
//  LLDBFileHandle.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/02/02.
//
//

#pragma once
#import "LLDBObject.h"
#import "LLDBDeclarations.h"
#import "LLDBEnums.h"

///	Wraps C file stream handle `FILE*`.
///
@interface	LLDBFileHandle : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;

@property	(readonly,nonatomic,assign)		FILE*	fileStreamHandle;
@property	(readonly,nonatomic,assign)		int		fileDescriptor;

- (void)flush;

- (BOOL)isEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isEqual:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (NSString *)description UNIVERSE_UNAVAILABLE_METHOD;
@end
