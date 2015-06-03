//
//  LLDBValue.h
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#pragma once
#import "LLDBObject.h"
#import "LLDBDeclarations.h"
#import "LLDBEnums.h"

@interface LLDBValue : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;


@property	(readonly,nonatomic,copy)		LLDBError*			error;
@property	(readonly,nonatomic,assign)		LLDBUserIDType		ID;
@property	(readonly,nonatomic,copy)		NSString*			name;
@property	(readonly,nonatomic,copy)		NSString*			typeName;
@property	(readonly,nonatomic,assign)		size_t				byteSize;
@property	(readonly,nonatomic,assign)		BOOL				isInScope;
@property	(readwrite,nonatomic,assign)	LLDBFormat			format;
@property	(readonly,nonatomic,copy)		NSString*			valueExpression;		///<	`SBValue::GetValue()`.



@property	(readonly,nonatomic,assign)		LLDBValueType		valueType;
@property	(readonly,nonatomic,assign)		BOOL				valueDidChange;
@property	(readonly,nonatomic,copy)		NSString*			summary;
@property	(readonly,nonatomic,copy)		NSString*			objectDescription;
//- (LLDBValue*)dynamicValue:(BOOL)useDynamic;
//@property	(readonly,nonatomic,copy)		LLDBValue*				staticValue;
//@property	(readonly,nonatomic,copy)		LLDBValue*				nonSyntheticValue;
//@property	(readwrite,nonatomic,assign)	LLDBDynamicValueType	preferDynamicValue;
//@property	(readwrite,nonatomic,assign)	BOOL					preferSyntheticValue;
//@property	(readonly,nonatomic,assign)		BOOL					isDynamic;
//@property	(readonly,nonatomic,assign)		BOOL					isSynthetic;
@property	(readonly,nonatomic,copy)		NSString*				location;




//@property	(readonly,nonatomic,copy)		LLDBTypeFormat*			typeFormat;
//@property	(readonly,nonatomic,copy)		LLDBTypeSummary*		typeSummary;
//@property	(readonly,nonatomic,copy)		LLDBTypeFilter*			typeFilter;
//@property	(readonly,nonatomic,copy)		LLDBTypeSynthetic*		typeSynthetic;
- (LLDBValue*)childAtIndex:(uint32_t)index;












////------------------------------------------------------------------
///// Get a child value by index from a value.
/////
///// Structs, unions, classes, arrays and and pointers have child
///// values that can be access by index.
/////
///// Structs and unions access child members using a zero based index
///// for each child member. For
/////
///// Classes reserve the first indexes for base classes that have
///// members (empty base classes are omitted), and all members of the
///// current class will then follow the base classes.
/////
///// Pointers differ depending on what they point to. If the pointer
///// points to a simple type, the child at index zero
///// is the only child value available, unless \a synthetic_allowed
///// is \b true, in which case the pointer will be used as an array
///// and can create 'synthetic' child values using positive or
///// negative indexes. If the pointer points to an aggregate type
///// (an array, class, union, struct), then the pointee is
///// transparently skipped and any children are going to be the indexes
///// of the child values within the aggregate type. For example if
///// we have a 'Point' type and we have a SBValue that contains a
///// pointer to a 'Point' type, then the child at index zero will be
///// the 'x' member, and the child at index 1 will be the 'y' member
///// (the child at index zero won't be a 'Point' instance).
/////
///// Arrays have a preset number of children that can be accessed by
///// index and will returns invalid child values for indexes that are
///// out of bounds unless the \a synthetic_allowed is \b true. In this
///// case the array can create 'synthetic' child values for indexes
///// that aren't in the array bounds using positive or negative
///// indexes.
/////
///// @param[in] idx
/////     The index of the child value to get
/////
///// @param[in] use_dynamic
/////     An enumeration that specifies wether to get dynamic values,
/////     and also if the target can be run to figure out the dynamic
/////     type of the child value.
/////
///// @param[in] synthetic_allowed
/////     If \b true, then allow child values to be created by index
/////     for pointers and arrays for indexes that normally wouldn't
/////     be allowed.
/////
///// @return
/////     A new SBValue object that represents the child member value.
////------------------------------------------------------------------
//- (LLDBValue*)childAtIndex:(uint32_t)index dynamicValueType:(LLDBDynamicValueType)dynamicValueType canCreateSynthetic:(BOOL)canCreateSynthetic;






@property	(readonly,nonatomic,copy)		LLDBValue*				addressOf;
@property	(readonly,nonatomic,assign)		LLDBAddressType			loadAddress;
@property	(readonly,nonatomic,copy)		LLDBAddress*			address;


@property	(readonly,nonatomic,copy)		LLDBData*				data;
//@property	(readonly,nonatomic,copy)		LLDBDeclaration*		declaration;




//------------------------------------------------------------------
/// Find out if a SBValue might have children.
///
/// This call is much more efficient than GetNumChildren() as it
/// doesn't need to complete the underlying type. This is designed
/// to be used in a UI environment in order to detect if the
/// disclosure triangle should be displayed or not.
///
/// This function returns true for class, union, structure,
/// pointers, references, arrays and more. Again, it does so without
/// doing any expensive type completion.
///
/// @return
///     Returns \b true if the SBValue might have children, or \b
///     false otherwise.
//------------------------------------------------------------------
@property	(readonly,nonatomic,assign)		BOOL					mightHaveChilren;
@property	(readonly,nonatomic,assign)		uint32_t				numberOfChildren;
@property	(readonly,nonatomic,assign)		void*					opaqueType;
@property	(readonly,nonatomic,copy)		LLDBTarget*				target;
@property	(readonly,nonatomic,copy)		LLDBProcess*			process;
@property	(readonly,nonatomic,copy)		LLDBThread*				thread;
@property	(readonly,nonatomic,copy)		LLDBFrame*				frame;
@property	(readonly,nonatomic,copy)		LLDBValue*				dereference;
@property	(readonly,nonatomic,assign)		BOOL					typeIsPointerType;
//@property	(readonly,nonatomic,copy)		LLDBType*				type;
@property	(readonly,nonatomic,copy)		NSString*				expressionPath;


//------------------------------------------------------------------
/// Watch this value if it resides in memory.
///
/// Sets a watchpoint on the value.
///
/// @param[in] resolve_location
///     Resolve the location of this value once and watch its address.
///     This value must currently be set to \b true as watching all
///     locations of a variable or a variable path is not yet supported,
///     though we plan to support it in the future.
///
/// @param[in] read
///     Stop when this value is accessed.
///
/// @param[in] write
///     Stop when this value is modified
///
/// @param[out]
///     An error object. Contains the reason if there is some failure.
///
/// @return
///     An SBWatchpoint object. This object might not be valid upon
///     return due to a value not being contained in memory, too
///     large, or watchpoint resources are not available or all in
///     use.
//------------------------------------------------------------------
- (LLDBWatchpoint*)watch:(BOOL)resolveLocation read:(BOOL)read write:(BOOL)write error:(LLDBError**)error;




//------------------------------------------------------------------
/// Watch this value that this value points to in memory
///
/// Sets a watchpoint on the value.
///
/// @param[in] resolve_location
///     Resolve the location of this value once and watch its address.
///     This value must currently be set to \b true as watching all
///     locations of a variable or a variable path is not yet supported,
///     though we plan to support it in the future.
///
/// @param[in] read
///     Stop when this value is accessed.
///
/// @param[in] write
///     Stop when this value is modified
///
/// @param[out]
///     An error object. Contains the reason if there is some failure.
///
/// @return
///     An SBWatchpoint object. This object might not be valid upon
///     return due to a value not being contained in memory, too
///     large, or watchpoint resources are not available or all in
///     use.
//------------------------------------------------------------------
- (LLDBWatchpoint*)watchPointee:(BOOL)resolveLocation read:(BOOL)read write:(BOOL)write error:(LLDBError**)error;








- (BOOL)isEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isEqual:(id)object UNIVERSE_UNAVAILABLE_METHOD;
@end
