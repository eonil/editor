//
//  LLDBData.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#pragma once
#import "LLDBObject.h"
#import "LLDBDeclarations.h"
#import "LLDBEnums.h"



@interface LLDBData : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;




@property	(readwrite,nonatomic,assign)	uint8_t				addressByteSize;
@property	(readonly,nonatomic,assign)		size_t				byteSize;
@property	(readwrite,nonatomic,assign)	LLDBByteOrder		byteOrder;

- (size_t)	readRawDataWithOffset:(LLDBOffsetType)offset buffer:(void*)buffer size:(size_t)size error:(LLDBError**)error;

// it would be nice to have SetData(SBError, const void*, size_t) when endianness and address size can be
// inferred from the existing DataExtractor, but having two SetData() signatures triggers a SWIG bug where
// the typemap isn't applied before resolving the overload, and thus the right function never gets called
- (void)	setDataWithBuffer:(void const*)buffer size:(size_t)size endian:(LLDBByteOrder)endian addressSize:(uint8_t)addressSize error:(LLDBError**)error;


- (void)	append:(LLDBData*)data;



- (BOOL)isEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isEqual:(id)object UNIVERSE_UNAVAILABLE_METHOD;
@end
