//
//  UniverseCommon.h
//  Spacetime
//
//  Created by Hoon H. on 14/5/26.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

#pragma once
#ifdef	__cplusplus
extern "C"
{
#endif

	
#ifdef	__cplusplus
#import <Foundation/NSString.h>
#else
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#endif

	
	
	
	
/*!
 Uses Xcode default debugging flag.
 */
#ifndef	EONIL_DEBUG_MODE
#ifdef	DEBUG
#if		DEBUG
#define EONIL_DEBUG_MODE		1
#endif
#endif
#endif
	
/*!
 Treat relese mode if nothing specified 
 after all the checks.
 */
#ifndef	EONIL_DEBUG_MODE
#error	"You must define `EONIL_DEBUG_MODE` macro."
#endif

	
	
	



#define UNIVERSE_DEPRECATED_CLASS							__attribute__((deprecated))

#define UNIVERSE_UNAVAILABLE_METHOD							__attribute__((unavailable))
#define UNIVERSE_DEPRECATED_METHOD							__attribute__((deprecated))
#define UNIVERSE_NON_RETURNING_METHOD						__attribute__((noreturn))

#define	UNIVERSE_ERROR_LOG(...)								{ _universe_error_log(([NSString stringWithFormat:__VA_ARGS__])); }
#define UNIVERSE_FORBIDDEN_METHOD()							{ UNIVERSE_ERROR_LOG(@"Calling of this method has been forbidden. Do not call this method."); [((NSObject*)self) doesNotRecognizeSelector:_cmd]; abort(); };
#define UNIVERSE_DELETED_METHOD()							{ UNIVERSE_ERROR_LOG(@"This method semantically deleted. Do not call this method.%@", @""); [((NSObject*)self) doesNotRecognizeSelector:_cmd]; abort(); };
#define UNIVERSE_UNIMPLEMENTED_METHOD()						{ UNIVERSE_ERROR_LOG(@"This method should be exists here, but has not yet been implemented. Please contact the developer.%@", @""); [self doesNotRecognizeSelector:_cmd]; abort(); };

#if		EONIL_DEBUG_MODE
void	_universe_error_log(NSString* message);
void	UNIVERSE_DEBUG_ASSERT(BOOL cond);					
void	UNIVERSE_DEBUG_ASSERT_WITH_MESSAGE(BOOL cond, NSString* message);
#define	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(obj,type)			UNIVERSE_DEBUG_ASSERT([((NSObject*)obj) isKindOfClass:[type class]])
#define	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE_OR_NIL(obj,type)	UNIVERSE_DEBUG_ASSERT([((NSObject*)obj) isKindOfClass:[type class]] || obj == nil)
#define	UNIVERSE_DEBUG_ASSERT_PROTOCOL_CONFORMANCE(obj,pro)	UNIVERSE_DEBUG_ASSERT([(id)(obj) conformsToProtocol:@protocol(pro)])
//void	UNIVERSE_DEBUG_ASSERT_FOR_EACH_ELEMENTS_IN_ARRAY(NSArray* elements, BOOL(^test)(id element));																							///<	Will be deprecated. Use UNIVERSE_DEBUG_RUN_FOR_EACH macro insted of.
//#define	UNIVERSE_DEBUG_ASSERT_FOR_EACH_ELEMENTS_TYPE_IN_ARRAY(arr,type)	UNIVERSE_DEBUG_ASSERT_FOR_EACH_ELEMENTS_IN_ARRAY((arr), ^(id e){ return [e isKindOfClass:[type class]]; });				///<	Will be deprecated. Use UNIVERSE_DEBUG_RUN_FOR_EACH macro insted of.
//void	UNIVERSE_DEBUG_RUN_FOR_EACH(id collection, void(^block)(id element));		///<	Runs the block for all each elements in the collection only in debug build.
void	UNIVERSE_UNREACHABLE_CODE() UNIVERSE_NON_RETURNING_METHOD;
#else
#define	_universe_error_log(message)
#define	UNIVERSE_DEBUG_ASSERT(cond)
#define	UNIVERSE_DEBUG_ASSERT_WITH_MESSAGE(cond,message)
#define	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(obj,type)
#define	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE_OR_NIL(obj,type)
#define	UNIVERSE_DEBUG_ASSERT_PROTOCOL_CONFORMANCE(obj,pro)
//#define	UNIVERSE_DEBUG_ASSERT_FOR_EACH_ELEMENTS_IN_ARRAY(elements,block);
//#define	UNIVERSE_DEBUG_ASSERT_FOR_EACH_ELEMENTS_TYPE_IN_ARRAY(arr,type)
//#define	UNIVERSE_DEBUG_RUN_FOR_EACH(collection,block)
#define	UNIVERSE_UNREACHABLE_CODE()							__builtin_unreachable()
#endif



extern NSString* const	UNIVERSE_DOCUMENT_AUTOSAVE_WINDOW_OUTER_SPLIT;
extern NSString* const	UNIVERSE_DOCUMENT_AUTOSAVE_WINDOW_INNER_SPLIT;


	

	
#ifdef __cplusplus
}
#endif