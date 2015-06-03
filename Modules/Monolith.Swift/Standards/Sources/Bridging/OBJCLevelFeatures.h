////
////  OBJCLevelFeatures.h
////  Monolith
////
////  Created by Hoon H. on 10/20/14.
////
////
//
//#ifndef Monolith_OBJCLevelFeatures_h
//#define Monolith_OBJCLevelFeatures_h
//
//#import <Foundation/Foundation.h>
//
///*!
// Cocoa URL escaping algorithm intentionally ignores some characters,
// and that causes some problems. This forces Cocoa to escape ALL the
// characters regardless of the character classes. Enforced characters
// are special characters defined in RFC 1808 BNF table.
// 
// Writte as @code static inline @endcode to avoid making referenceable 
// symbol.
// */
//static inline NSString*
//____URLEncode(NSString* s0) {
//	CFStringRef const	t1	=	CFSTR("$-_.+!*'(),{}|\\^~[]`;/?:@&=<>#%\"");	//	Force these characters to be encoded.
//	
//	CFStringRef	const	s1	=	(__bridge CFStringRef)s0;
//	CFStringRef const	s2	=	CFURLCreateStringByAddingPercentEscapes(NULL, s1, NULL, t1, kCFStringEncodingUTF8);
//	CFStringRef const	s3	=	CFAutorelease(s2);
//	NSString* const		s4	=	(__bridge NSString*)s3;
//	return				s4	;
//}
//
//#endif
