//
//  NSObject+Universe.h
//  Spacetime
//
//  Created by Hoon H. on 14/5/26.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

#pragma once
#import "UniverseCommon.h"

@interface NSObject (Universe)
+ (id)allocWithZone:(struct _NSZone *)zone UNIVERSE_UNAVAILABLE_METHOD;
+ (id)copyWithZone:(struct _NSZone *)zone UNIVERSE_UNAVAILABLE_METHOD;
+ (id)mutableCopyWithZone:(struct _NSZone *)zone UNIVERSE_UNAVAILABLE_METHOD;
+ (id)new UNIVERSE_UNAVAILABLE_METHOD;
- (id)copy UNIVERSE_UNAVAILABLE_METHOD;
+ (id)alloc UNIVERSE_UNAVAILABLE_METHOD;
//+ (instancetype)instantiation __attribute__((objc_method_family(new)));		//	Do not put the family attribute. Because returnning object is just plain `strong` semantics.
@end