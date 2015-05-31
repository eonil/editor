//
//  LLDBBreakpointLocation.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#pragma once
#import	"LLDBObject.h"
#import "LLDBDeclarations.h"

@interface LLDBBreakpointLocation : NSObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;


//@property	(readonly,nonatomic,copy)	LLDBAddress*		address;


- (BOOL)isEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isEqual:(id)object UNIVERSE_UNAVAILABLE_METHOD;
@end
