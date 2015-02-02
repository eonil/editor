//
//  BasicObject.h
//  LLDBWrapepr
//
//  Created by Hoon H. on 2015/01/19.
//
//

#pragma once
#import <Foundation/Foundation.h>
#import "UniverseCommon.h"

//
//  BasicObject.h
//  Spacetime
//
//  Created by Hoon H. on 14/5/26.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

#import "UniverseCommon.h"
#import "NSObject+Universe.h"

/*!
 Any `init~` series methods are allowed to be called only once right after allocation.
 Calling initialization method multiple times are illegal.
 */
@interface BasicObject : NSObject
+ (id)allocWithZone:(struct _NSZone *)zone UNIVERSE_UNAVAILABLE_METHOD;
+ (id)copyWithZone:(struct _NSZone *)zone UNIVERSE_UNAVAILABLE_METHOD;
+ (id)mutableCopyWithZone:(struct _NSZone *)zone UNIVERSE_UNAVAILABLE_METHOD;
- (id)mutableCopy UNIVERSE_UNAVAILABLE_METHOD;
+ (id)new UNIVERSE_UNAVAILABLE_METHOD;
- (id)copy UNIVERSE_UNAVAILABLE_METHOD;
- (id)copyScriptingValue:(id)value forKey:(NSString *)key withProperties:(NSDictionary *)properties UNIVERSE_UNAVAILABLE_METHOD;
@end