//
//  UniverseDoctor.h
//  Spacetime
//
//  Created by Hoon H. on 14/5/26.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

#pragma once
#import "BasicObject.h"



@interface	UniverseException : NSException
+ (id)allocWithZone:(struct _NSZone *)zone UNIVERSE_UNAVAILABLE_METHOD;
+ (id)copyWithZone:(struct _NSZone *)zone UNIVERSE_UNAVAILABLE_METHOD;
- (id)initWithCoder:(NSCoder *)aDecoder UNIVERSE_UNAVAILABLE_METHOD;
+ (void)raise:(NSString *)name format:(NSString *)format, ... UNIVERSE_UNAVAILABLE_METHOD;
+ (void)raise:(NSString *)name format:(NSString *)format arguments:(va_list)argList UNIVERSE_UNAVAILABLE_METHOD;
@end

/*!
 Resoverable exception.
 Usually happen by bad input.
 
 @note
 I don't like this name. Figure out better one.
 */
@interface	UniverseCancellation : UniverseException
@end

/*!
 Unrecoverable exception.
 This means program state is already corrupted, and cannot continue execution.
 */
@interface	UniverseCorruption : UniverseException
@end










@interface	UniverseDoctor : BasicObject
+ (void)	except UNIVERSE_NON_RETURNING_METHOD;
+ (void)	exceptWithMessage:(NSString*)message UNIVERSE_NON_RETURNING_METHOD;
+ (void)	exceptIf:(BOOL)condition;
+ (void)	exceptIf:(BOOL)condition withMessage:(NSString*)message;
+ (void)	panic UNIVERSE_NON_RETURNING_METHOD;
+ (void)	panicWithMessage:(NSString*)message UNIVERSE_NON_RETURNING_METHOD;
+ (void)	panicIf:(BOOL)condition;
+ (void)	panicIf:(BOOL)condition withMessage:(NSString*)message;
@end
