//
//  LLDB_Internals_ObjectTranslation.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#pragma once
#import <Foundation/Foundation.h>


//static inline auto
//toC(NSString* string) -> char const*
//{
//	if (string == nil)
//	{
//		return	NULL;
//	}
//	else {
//		return	string.UTF8String;
//	}
//}



/*!
 `NSString` initialisers throws an exception of input is `NULL`.
 This filters and returns `nil` for `NULL` input.
 */
static inline auto
fromC(char const* string) -> NSString*
{
	if (string == NULL)
	{
		return	nil;
	}
	else {
		return	[NSString stringWithUTF8String:string];
	}
}





