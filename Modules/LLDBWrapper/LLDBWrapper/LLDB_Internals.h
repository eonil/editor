//
//  LLDB_Internals.h
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/6/14.
//
//

#pragma once
#import <LLDB/LLDB.h>
#import <LLDB/SBModuleSpec.h>
#import <LLDB/SBTypeCategory.h>
#import <LLDB/SBTypeFilter.h>
#import <LLDB/SBTypeFormat.h>
#import <LLDB/SBTypeNameSpecifier.h>
#import <LLDB/SBTypeSummary.h>
#import <LLDB/SBTypeSynthetic.h>

#import "LLDBObject.h"
#import "LLDBDebugger.h"
#import "LLDBTarget.h"
#import "LLDBBreakpoint.h"
#import "LLDBBreakpointLocation.h"
#import "LLDBWatchpoint.h"

#import "LLDBSourceManager.h"
#import "LLDBCompileUnit.h"
#import "LLDBFileSpec.h"
#import "LLDBLineEntry.h"

#import "LLDBProcess.h"
#import "LLDBThread.h"
#import "LLDBFrame.h"
#import "LLDBFunction.h"
#import "LLDBBlock.h"
#import "LLDBInstructionList.h"
#import "LLDBInstruction.h"
#import "LLDBSymbol.h"
#import "LLDBValueList.h"
#import "LLDBValue.h"


#import "LLDBSourceManager.h"
#import "LLDBModule.h"
#import "LLDBModuleSpec.h"
#import "LLDBSymbolContext.h"
#import "LLDBSymbolContextList.h"


#import "LLDBBroadcaster.h"
#import "LLDBEvent.h"
#import "LLDBListener.h"

#import "LLDBDeclaration.h"
#import "LLDBHostOS.h"
#import "LLDBSection.h"

#import "LLDBType.h"
#import "LLDBTypeCategory.h"
#import "LLDBTypeFilter.h"
#import "LLDBTypeFormat.h"
#import "LLDBTypeNameSpecifier.h"
#import "LLDBTypeSummary.h"
#import "LLDBTypeSynthetic.h"


#import "LLDBData.h"
#import "LLDBError.h"
#import "LLDBFileHandle.h"
#import "LLDBAddress.h"



#import "LLDB_Internals_EnumTranslation.h"
#import "LLDB_Internals_ObjectTranslation.h"




















@interface	LLDBProcess ()
{
	@package
	lldb::SBProcess		_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBProcess)raw;
@end

@interface	LLDBThread ()
{
	@package
	lldb::SBThread		_raw;
}
+ (LLDBThread*)threadWithMaybeCPPObject:(lldb::SBThread)raw;
- (instancetype)initWithCPPObject:(lldb::SBThread)raw;
@end

@interface	LLDBFrame ()
{
	@package
	lldb::SBFrame		_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBFrame)raw;
@end

@interface	LLDBFunction ()
{
	@package
	lldb::SBFunction	_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBFunction)raw;
@end

@interface	LLDBInstructionList ()
{
	@package
	lldb::SBInstructionList	_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBInstructionList)raw;
@end

@interface	LLDBInstruction ()
{
	@package
	lldb::SBInstruction		_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBInstruction)raw;
@end

@interface	LLDBSymbol ()
{
	@package
	lldb::SBSymbol			_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBSymbol)raw;
@end

@interface	LLDBValueList ()
{
	@package
	lldb::SBValueList		_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBValueList)raw;
@end

@interface	LLDBValue ()
{
	@package
	lldb::SBValue			_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBValue)raw;
@end








@interface LLDBAddress ()
{
	@package
	lldb::SBAddress			_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBAddress)raw;
@end

@interface LLDBBlock ()
{
	@package
	lldb::SBBlock			_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBBlock)raw;
@end










@interface LLDBBroadcaster ()
{
	@package
	lldb::SBBroadcaster		_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBBroadcaster)raw;
@end

@interface LLDBEvent ()
{
	@package
	lldb::SBEvent			_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBEvent)raw;
@end

@interface LLDBListener ()
{
	@package
	lldb::SBListener		_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBListener)raw;
@end














@interface LLDBDeclaration ()
{
	@package
	lldb::SBDeclaration		_raw;
}
@end


@interface LLDBHostOS ()
{
	@package
	lldb::SBHostOS			_raw;
}
@end












//@interface LLDBStream ()
//{
//	@package
//	lldb::SBStream				_raw;
//}
//@end

//@interface LLDBStringList ()
//{
//	@package
//	lldb::SBStringList			_raw;
//}
//@end

@interface LLDBSymbolContext ()
{
	@package
	lldb::SBSymbolContext		_raw;
}
@end

@interface LLDBSymbolContextList ()
{
	@package
	lldb::SBSymbolContextList	_raw;
}
@end

@interface LLDBType ()
{
	@package
	lldb::SBType				_raw;
}
@end

@interface LLDBTypeCategory ()
{
	@package
	lldb::SBTypeCategory		_raw;
}
@end

@interface LLDBTypeFilter ()
{
	@package
	lldb::SBTypeFilter			_raw;
}
@end

@interface LLDBTypeFormat ()
{
	@package
	lldb::SBTypeFormat			_raw;
}
@end

@interface LLDBTypeNameSpecifier ()
{
	@package
	lldb::SBTypeNameSpecifier	_raw;
}
@end

@interface LLDBTypeSummary ()
{
	@package
	lldb::SBTypeSummary			_raw;
}
@end

@interface LLDBTypeSynthetic ()
{
	@package
	lldb::SBTypeSynthetic		_raw;
}
@end





































#pragma mark	-
#pragma mark	Driver Interface



@interface	LLDBDebugger ()
{
	@package
	lldb::SBDebugger	_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBDebugger)raw;
@end

@interface	LLDBTarget ()
{
	@package
	lldb::SBTarget		_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBTarget)raw;
@end

@interface	LLDBBreakpoint ()
{
	@package
	lldb::SBBreakpoint	_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBBreakpoint)raw;
@end

@interface	LLDBBreakpointLocation ()
{
	@package
	lldb::SBBreakpointLocation	_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBBreakpointLocation)raw;
@end

@interface LLDBWatchpoint ()
{
	@package
	lldb::SBWatchpoint			_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBWatchpoint)raw;
@end
























#pragma mark	-
#pragma mark	Execution States

























#pragma mark	-
#pragma mark	Code Database

@interface	LLDBModule ()
{
	@package
	lldb::SBModule			_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBModule)raw;
@end

@interface LLDBModuleSpec ()
{
	@package
	lldb::SBModuleSpec		_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBModuleSpec)raw;
@end

@interface LLDBSection ()
{
	@package
	lldb::SBSection			_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBSection)raw;
@end


























#pragma mark	-
#pragma mark	Source Tracking

@interface	LLDBSourceManager ()
{
	@package
	
	///	This need to be a pointer because SBSourceManager does not have
	///	a proper empty-state that are required to an Objective-C++ class.
	///
	///	It is possible to hack this around uninitialsed memory, but it's too complex and unsafe when
	///	compared to its benefit -- save of single pointer allocation that is not frequently required.
	lldb::SBSourceManager*	_rawptr;
}
- (instancetype)initWithCPPObject:(lldb::SBSourceManager)rawptr;
@end

@interface LLDBCompileUnit ()
{
	@package
	lldb::SBCompileUnit		_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBCompileUnit)raw;
@end

@interface	LLDBFileSpec ()
{
	@package
	lldb::SBFileSpec	_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBFileSpec)raw;
@end

@interface LLDBLineEntry ()
{
	@package
	lldb::SBLineEntry		_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBLineEntry)raw;
//+ (LLDBLineEntry*)lineEntryWithMaybeCPPObject:(lldb::SBLineEntry)maybeCPPObject;		///<	Accepts invalid C++ object. Returns `nil` if C++ object is invalid.
@end

























#pragma mark	-	Infrastructures



@interface	LLDBError ()
{
	@package
	lldb::SBError			_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBError)raw;						///<	Accepts no invalid C++ object. Never returns a `nil`. Crashes if `[super init]` returns `nil` (out of memory situation). You're responsible to keep some memory available.
//+ (LLDBError*)errorWithMaybeCPPObject:(lldb::SBError)maybeCPPObject;		///<	Accepts invalid C++ object. Returns `nil` if C++ object is invalid.
@end

@interface LLDBData ()
{
	@package
	lldb::SBData			_raw;
}
- (instancetype)initWithCPPObject:(lldb::SBData)raw;
@end

@interface LLDBFileHandle ()
{
	@package
	FILE*					_raw;
}
- (instancetype)initWithCObject:(FILE*)raw;
@end

@interface	LLDBObject ()
@end

















#pragma mark	-











//
//template <typename T>
//static inline T*
//proxy_init(T* self, decltype(self->_raw) newRaw) {
//	if (newRaw.IsValid()) {
//		self->_raw	=	newRaw;
//		return	self;
//	} else {
//		return	nil;
//	}
//}
//
//
//template <typename RAW, typename WRAPPER>
//static inline WRAPPER*
//try_instantiation_of_wrapper(RAW raw)
//{
//	if (raw.IsValid())
//	{
//		WRAPPER*	w1		=	[[WRAPPER alloc] init];
//		w1->_raw			=	raw;
//		return	w1;
//	}
//	return	nil;
//}
//
//
//
//
//
//static inline BOOL
//handle_error(lldb::SBError const& error, LLDBError** output)
//{
//	BOOL			ok1		=	error.IsValid() and error.Success();
//	
//	if (ok1 == NO && output != NULL)
//	{
//		*output			=	[[LLDBError alloc] initWithCPPObject:error];
//	}
//	
//	return	ok1;
//}












template <typename T>
static inline NSString*
get_description_of(T _raw)
{
	lldb::SBStream	s;
	bool			r	=	_raw.GetDescription(s);
	UNIVERSE_DEBUG_ASSERT(r == true);
	
	NSString*		s1	=	[[NSString alloc] initWithBytes:s.GetData() length:s.GetSize() encoding:NSUTF8StringEncoding];
	return			s1;
}
template <typename T>
static inline NSString*
get_description_of(T _raw, lldb::DescriptionLevel level)
{
	lldb::SBStream	s;
	bool			r	=	_raw.GetDescription(s, level);
	UNIVERSE_DEBUG_ASSERT(r == true);
	
	NSString*		s1	=	[[NSString alloc] initWithBytes:s.GetData() length:s.GetSize() encoding:NSUTF8StringEncoding];
	return			s1;
}










//#define LLDBOBJECT_INIT_IMPL(typename)					\
//	- (instancetype)initWithCPPObject:(typename)raw		\
//	{													\
//		if (raw.IsValid() == false)						\
//		{												\
//			return	nil;								\
//		}												\
//														\
//		UNIVERSE_DEBUG_ASSERT(raw.IsValid() == true);	\
//		if (self = [super init]) {						\
//			_raw	=	raw;							\
//		}												\
//		else											\
//		{												\
//			UNIVERSE_DEBUG_ASSERT_WITH_MESSAGE(NO, @"`[super init]` returned `nil`. This situation is not supported.");		\
//		}												\
//		return	self;									\
//	}
//
//

#define LLDBOBJECT_INIT_IMPL(typename)					\
	- (instancetype)initWithCPPObject:(typename)raw		\
	{													\
		if (self = [super init]) {						\
			_raw	=	raw;							\
		}												\
		else											\
		{												\
			UNIVERSE_DEBUG_ASSERT_WITH_MESSAGE(NO, @"`[super init]` returned `nil`. This situation is not supported.");		\
		}												\
		return	self;									\
	}



