//
//  LLDBSection.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#pragma once
#import "LLDBObject.h"
#import "LLDBDeclarations.h"
#import "LLDBEnums.h"

@interface LLDBSection : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;


@property	(readonly,nonatomic,copy)	NSString*		name;
@property	(readonly,nonatomic,copy)	LLDBSection*	parentSection;
- (LLDBSection*)findSubsectionWithName:(NSString*)sectionName;
@property	(readonly,nonatomic,assign)	size_t			numberOfSubsections;
- (LLDBSection*)subsectionAtIndex:(size_t)index;



@property	(readonly,nonatomic,assign)	LLDBAddressType		fileAddress;
- (LLDBAddressType)loadAddressWithTarget:(LLDBTarget*)target;



@property	(readonly,nonatomic,assign)	LLDBAddressType		byteSize;
@property	(readonly,nonatomic,assign)	uint64_t			fileOffset;
@property	(readonly,nonatomic,assign)	uint64_t			fileByteSize;
@property	(readonly,nonatomic,copy)	LLDBData*			sectionData;
//- (LLDBData*)sectionDataWithOffset:(uint64_t)offset size:(uint64_t)size;



@property	(readonly,nonatomic,assign)	LLDBSectionType		sectionType;





- (BOOL)isEqualToSection:(LLDBSection*)object;
- (BOOL)isEqual:(id)object;

@end
