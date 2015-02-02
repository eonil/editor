//
//  LLDBSection.m
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#import "LLDBSection.h"
#import "LLDB_Internals.h"

@implementation LLDBSection
LLDBOBJECT_INIT_IMPL(lldb::SBSection);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}










- (NSString *)name
{
	return	fromC(_raw.GetName());
}
- (LLDBSection *)parentSection
{
	return	[[LLDBSection alloc] initWithCPPObject:_raw.GetParent()];
}
- (LLDBSection *)findSubsectionWithName:(NSString *)sectionName
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(sectionName, NSString);
	
	return	[[LLDBSection alloc] initWithCPPObject:_raw.FindSubSection(sectionName.UTF8String)];
}
- (size_t)numberOfSubsections
{
	return	_raw.GetNumSubSections();
}
- (LLDBSection *)subsectionAtIndex:(size_t)index
{
	return	[[LLDBSection alloc] initWithCPPObject:_raw.GetSubSectionAtIndex(index)];
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






- (LLDBAddressType)byteSize
{
	return	_raw.GetByteSize();
}
- (uint64_t)fileOffset
{
	return	_raw.GetFileOffset();
}
- (uint64_t)fileByteSize
{
	return	_raw.GetFileByteSize();
}
- (LLDBData *)sectionData
{
	return	[[LLDBData alloc] initWithCPPObject:_raw.GetSectionData()];
}
//- (id)sectionDataWithOffset:(uint64_t)offset size:(uint64_t)size
//{
//	
//}
- (LLDBSectionType)sectionType
{
	return	fromCPP(_raw.GetSectionType());
}
















- (BOOL)isEqualToSection:(LLDBSection *)object
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(object, LLDBSection);
	return	_raw.operator==(object->_raw);
}
- (BOOL)isEqualTo:(id)object
{
	if (self == object)
	{
		return	YES;
	}
	
	if ([object isKindOfClass:[LLDBSection class]])
	{
		return	[self isEqualToSection:object];
	}
	
	return	NO;
}
- (BOOL)isEqual:(id)object
{
	return	[self isEqualTo:object];
}


- (NSString *)description
{
	return	get_description_of(_raw);
}
@end
