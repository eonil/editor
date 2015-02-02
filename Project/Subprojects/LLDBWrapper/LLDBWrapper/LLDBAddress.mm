//
//  LLDBAddress.m
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#import "LLDBAddress.h"
#import "LLDB_Internals.h"

@implementation LLDBAddress
LLDBOBJECT_INIT_IMPL(lldb::SBAddress);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}











- (LLDBAddressType)fileAddress
{
	return	_raw.GetFileAddress();
}
- (LLDBAddressType)loadAddressWithTarget:(LLDBTarget *)target
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(target, LLDBTarget);
	
	return	_raw.GetLoadAddress(target->_raw);
}
- (void)setAddressWithSection:(LLDBSection *)section offset:(LLDBAddressType)offset
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(section, LLDBSection);
	
	_raw.SetAddress(section->_raw, offset);
}
- (void)setLoadAddress:(LLDBAddressType)loadAddress target:(LLDBTarget *)target
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(target, LLDBTarget);
	
	_raw.SetLoadAddress(loadAddress, target->_raw);
}
- (BOOL)offsetAddress:(LLDBAddressType)offset
{
	return	_raw.OffsetAddress(offset) == true;
}









- (LLDBSection *)section
{
	return	[[LLDBSection alloc] initWithCPPObject:_raw.GetSection()];
}
- (LLDBAddressType)offset
{
	return	_raw.GetOffset();
}
- (LLDBModule *)module
{
	return	[[LLDBModule alloc] initWithCPPObject:_raw.GetModule()];
}
- (LLDBCompileUnit *)compileUnit
{
	return	[[LLDBCompileUnit alloc] initWithCPPObject:_raw.GetCompileUnit()];
}
- (LLDBFunction *)function
{
	return	[[LLDBFunction alloc] initWithCPPObject:_raw.GetFunction()];
}
- (LLDBBlock *)block
{
	return	[[LLDBBlock alloc] initWithCPPObject:_raw.GetBlock()];
}
- (LLDBSymbol *)symbol
{
	return	[[LLDBSymbol alloc] initWithCPPObject:_raw.GetSymbol()];
}
- (LLDBLineEntry *)lineEntry
{
	return	[[LLDBLineEntry alloc] initWithCPPObject:_raw.GetLineEntry()];
}
- (LLDBAddressClass)addressClass
{
	return	fromCPP(_raw.GetAddressClass());
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
