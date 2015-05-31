//
//  LLDBValue.m
//  InteractiveDebugger
//
//  Created by Hoon H. on 9/7/14.
//
//

#import "LLDBValue.h"
#import "LLDB_Internals.h"

@implementation LLDBValue
LLDBOBJECT_INIT_IMPL(lldb::SBValue);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}










- (LLDBError *)error
{
	return	[[LLDBError alloc] initWithCPPObject:_raw.GetError()];
}
- (LLDBUserIDType)ID
{
	return	_raw.GetID();
}
- (NSString *)name
{
	return	fromC(_raw.GetName());
}
- (NSString *)typeName
{
	return	fromC(_raw.GetTypeName());
}
- (size_t)byteSize
{
	return	_raw.GetByteSize();
}
- (BOOL)isInScope
{
	return	_raw.IsInScope() == true;
}
- (LLDBFormat)format
{
	return	fromCPP(_raw.GetFormat());
}
- (void)setFormat:(LLDBFormat)format
{
	return	_raw.SetFormat(toCPP(format));
}
- (NSString *)valueExpression
{
	return	fromC(_raw.GetValue());
}









- (LLDBValueType)valueType
{
	return	fromCPP(_raw.GetValueType());
}
- (BOOL)valueDidChange
{
	return	_raw.GetValueDidChange() == true;
}
- (NSString *)summary
{
	return	fromC(_raw.GetSummary());
}
- (NSString *)objectDescription
{
	return	fromC(_raw.GetObjectDescription());
}
- (NSString *)location
{
	return	fromC(_raw.GetLocation());
}




- (LLDBValue *)childAtIndex:(uint32_t)index
{
	UNIVERSE_DEBUG_ASSERT(index < _raw.GetNumChildren());
	
	return	[[LLDBValue alloc] initWithCPPObject:_raw.GetChildAtIndex(index)];
}
- (LLDBValue *)addressOf
{
	return	[[LLDBValue alloc] initWithCPPObject:_raw.AddressOf()];
}
- (LLDBAddressType)loadAddress
{
	return	_raw.GetLoadAddress();
}
- (LLDBAddress *)address
{
	return	[[LLDBAddress alloc] initWithCPPObject:_raw.GetAddress()];
}
- (LLDBData *)data
{
	return	[[LLDBData alloc] initWithCPPObject:_raw.GetData()];
}








- (BOOL)mightHaveChilren
{
	return	_raw.MightHaveChildren() == true;
}
- (uint32_t)numberOfChildren
{
	return	_raw.GetNumChildren();
}
- (void*)opaqueType
{
	return	_raw.GetOpaqueType();
}
- (LLDBTarget *)target
{
	return	[[LLDBTarget alloc] initWithCPPObject:_raw.GetTarget()];
}
- (LLDBProcess *)process
{
	return	[[LLDBProcess alloc] initWithCPPObject:_raw.GetProcess()];
}
- (LLDBThread *)thread
{
	return	[[LLDBThread alloc] initWithCPPObject:_raw.GetThread()];
}
- (LLDBFrame *)frame
{
	return	[[LLDBFrame alloc] initWithCPPObject:_raw.GetFrame()];
}
- (LLDBValue *)dereference
{
	return	[[LLDBValue alloc] initWithCPPObject:_raw.Dereference()];
}
- (BOOL)typeIsPointerType
{
	return	_raw.TypeIsPointerType() == true;
}
- (NSString *)expressionPath
{
	lldb::SBStream	s;
	bool			r	=	_raw.GetExpressionPath(s);
	UNIVERSE_DEBUG_ASSERT(r == true);
	
	NSString*		s1	=	[[NSString alloc] initWithBytes:s.GetData() length:s.GetSize() encoding:NSUTF8StringEncoding];
	return			s1;
}










- (LLDBWatchpoint *)watch:(BOOL)resolveLocation read:(BOOL)read write:(BOOL)write error:(LLDBError *__autoreleasing *)error
{
	UNIVERSE_DEBUG_ASSERT(error != nullptr);
	
	lldb::SBError	e{};
	auto const		r	=	[[LLDBWatchpoint alloc] initWithCPPObject:_raw.Watch(resolveLocation == YES, read == YES, write == YES, e)];
	*error				=	[[LLDBError alloc] initWithCPPObject:e];
	return	r;
}
- (LLDBWatchpoint *)watchPointee:(BOOL)resolveLocation read:(BOOL)read write:(BOOL)write error:(LLDBError *__autoreleasing *)error
{
	UNIVERSE_DEBUG_ASSERT(error != nullptr);
	
	lldb::SBError	e{};
	auto const		r	=	[[LLDBWatchpoint alloc] initWithCPPObject:_raw.WatchPointee(resolveLocation == YES, read == YES, write == YES, e)];
	*error				=	[[LLDBError alloc] initWithCPPObject:e];
	return	r;
}












- (BOOL)isEqualTo:(id)object
{
	UNIVERSE_DELETED_METHOD();
}
- (BOOL)isEqual:(id)object
{
	UNIVERSE_DELETED_METHOD();
}
- (NSString *)description
{
	return	get_description_of(_raw);
}
@end





















