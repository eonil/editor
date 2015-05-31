//
//  LLDBInstruction.h
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#pragma once
#import "LLDBObject.h"
#import	"LLDBDeclarations.h"

@interface LLDBInstruction : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;



- (NSString*)mnemonicForTarget:(LLDBTarget*)target;
- (NSString*)operandsForTarget:(LLDBTarget*)target;
- (NSString*)commentForTarget:(LLDBTarget*)target;







- (BOOL)isEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isEqual:(id)object UNIVERSE_UNAVAILABLE_METHOD;
@end

