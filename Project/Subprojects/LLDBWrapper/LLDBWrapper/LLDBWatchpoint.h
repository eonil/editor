//
//  LLDBWatchpoint.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#pragma once
#import "LLDBObject.h"
#import "LLDBDeclarations.h"

@interface LLDBWatchpoint : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;



@property	(readonly,nonatomic,copy)		LLDBError*			error;
@property	(readonly,nonatomic,assign)		LLDBWatchIDType		ID;


@property	(readonly,nonatomic,assign)		int32_t				hardwareIndex;
@property	(readonly,nonatomic,assign)		LLDBAddressType		watchAddress;
@property	(readonly,nonatomic,assign)		size_t				watchSize;


@property	(readwrite,nonatomic,assign,getter = isEnabled)		BOOL	enabled;

@property	(readonly,nonatomic,assign)		uint32_t			hitCount;
@property	(readwrite,nonatomic,assign)	uint32_t			ignoreCount;
@property	(readwrite,nonatomic,copy)		NSString*			condition;




- (BOOL)isEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isEqual:(id)object UNIVERSE_UNAVAILABLE_METHOD;
@end
