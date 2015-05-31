//
//  LLDBObject.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBObject.h"
#import "LLDB_Internals.h"

@implementation LLDBObject
- (instancetype)init
{
	return	[super init];
}
- (BOOL)isKindOfClass:(Class)aClass
{
	return	[super isKindOfClass:aClass];
}
- (void)doesNotRecognizeSelector:(SEL)aSelector
{
	[super doesNotRecognizeSelector:aSelector];
}
@end


//id
//LLDBObject_init(LLDBObject* self)
//{
//	return	[self int]
//}
//BOOL
//LLDBObject_isKindOfClass(LLDBObject* self, Class aClass)
//{
//}
//void
//LLDBObject_doesNotRecognizeSelector(LLDBObject* self, SEL aSelector)
//{
//	
//}