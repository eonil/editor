//
//  LLDBAddress.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#pragma once
#import "LLDBObject.h"
#import "LLDBDeclarations.h"
#import "LLDBEnums.h"

@interface LLDBAddress : LLDBObject
- (instancetype)init UNIVERSE_UNAVAILABLE_METHOD;


@property	(readonly,nonatomic,assign)		LLDBAddressType		fileAddress;
- (LLDBAddressType)loadAddressWithTarget:(LLDBTarget*)target;
- (void)	setAddressWithSection:(LLDBSection*)section offset:(LLDBAddressType)offset;
- (void)	setLoadAddress:(LLDBAddressType)loadAddress target:(LLDBTarget*)target;
- (BOOL)	offsetAddress:(LLDBAddressType)offset;


//// The following queries can lookup symbol information for a given address.
//// An address might refer to code or data from an existing module, or it
//// might refer to something on the stack or heap. The following functions
//// will only return valid values if the address has been resolved to a code
//// or data address using "void SBAddress::SetLoadAddress(...)" or
//// "lldb::SBAddress SBTarget::ResolveLoadAddress (...)".
//- (LLDBSymbolContext*)symbolContext:(uint32_t)resolveScope;



// The following functions grab individual objects for a given address and
// are less efficient if you want more than one symbol related objects.
// Use one of the following when you want multiple debug symbol related
// objects for an address:
//    lldb::SBSymbolContext SBAddress::GetSymbolContext (uint32_t resolve_scope);
//    lldb::SBSymbolContext SBTarget::ResolveSymbolContextForAddress (const SBAddress &addr, uint32_t resolve_scope);
// One or more bits from the SymbolContextItem enumerations can be logically
// OR'ed together to more efficiently retrieve multiple symbol objects.
@property	(readonly,nonatomic,copy)		LLDBSection*		section;
@property	(readonly,nonatomic,assign)		LLDBAddressType		offset;
@property	(readonly,nonatomic,copy)		LLDBModule*			module;
@property	(readonly,nonatomic,copy)		LLDBCompileUnit*	compileUnit;
@property	(readonly,nonatomic,copy)		LLDBFunction*		function;
@property	(readonly,nonatomic,copy)		LLDBBlock*			block;
@property	(readonly,nonatomic,copy)		LLDBSymbol*			symbol;
@property	(readonly,nonatomic,copy)		LLDBLineEntry*		lineEntry;
@property	(readonly,nonatomic,assign)		LLDBAddressClass	addressClass;



- (BOOL)isEqualTo:(id)object UNIVERSE_UNAVAILABLE_METHOD;
- (BOOL)isEqual:(id)object UNIVERSE_UNAVAILABLE_METHOD;
@end
