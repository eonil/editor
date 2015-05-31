//
//  LLDBDebugger.h
//  InteractiveDebugger
//
//  Created by Hoon H. on 14/8/17.
//
//

#pragma once
#import	"LLDBObject.h"
#import "LLDBDeclarations.h"
#import "LLDBEnums.h"



extern NSString* const		LLDBArchDefault;
extern NSString* const		LLDBArchDefault32Bit;
extern NSString* const		LLDBArchDefault64Bit;









@interface	LLDBDebugger : LLDBObject
- (instancetype)init;
@property	(readwrite,nonatomic,assign)	BOOL		async;





@property	(readonly,nonatomic,copy)		LLDBListener*			listener;






- (NSString*)stringOfState:(LLDBStateType)state;													///<	Use @c LLDBState~ constants.
- (LLDBTarget*)createTargetWithFilename:(NSString*)filename;
- (LLDBTarget*)createTargetWithFilename:(NSString*)filename andArchname:(NSString*)archname;		///<	You can use one of @c LLDBArchDefault~ constants.

- (void)	deleteTarget:(LLDBTarget*)target;


////@property	(readwrite,nonatomic,assign)	FILE*		inputFileHandle;
//@property	(readwrite,nonatomic,assign)	FILE*		outputFileHandle;								///<	Sets output file handle without transferring ownership.
//- (void)	setOutputFileHandle:(FILE *)outputFileHandle transferOwnership:(BOOL)transferOwnership;
////@property	(readwrite,nonatomic,assign)	FILE*		errorFileHandle;

//@property	(readwrite,nonatomic,strong)	LLDBFileHandle*			outputFileHandle;				///<	Sets output file handle without transferring ownership.


@property	(readonly,nonatomic,assign)		uint32_t	numberOfTargets;
- (LLDBTarget*)targetAtIndex:(uint32_t)index;
@property	(readonly,nonatomic,copy)		LLDBSourceManager*		sourceManager;

- (BOOL)isEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isEqual:(id)object UNIVERSE_UNAVAILABLE_METHOD;

@end









