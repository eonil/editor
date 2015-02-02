//
//  LLDBData.m
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#import "LLDBError.h"
#import "LLDB_Internals.h"

@implementation LLDBData
LLDBOBJECT_INIT_IMPL(lldb::SBData);
- (instancetype)init
{
	UNIVERSE_DELETED_METHOD();
}










- (uint8_t)addressByteSize
{
	return	_raw.GetAddressByteSize();
}
- (size_t)byteSize
{
	return	_raw.GetByteSize();
}
- (LLDBByteOrder)byteOrder
{
	return	fromCPP(_raw.GetByteOrder());
}
- (size_t)readRawDataWithOffset:(LLDBOffsetType)offset buffer:(void *)buffer size:(size_t)size error:(LLDBError *__autoreleasing *)error
{
	UNIVERSE_DEBUG_ASSERT(error != nullptr);
	
	lldb::SBError	e{};
	auto const		r	=	_raw.ReadRawData(e, offset, buffer, size);
	*error				=	[[LLDBError alloc] initWithCPPObject:e];
	return	r;
}
- (void)setDataWithBuffer:(const void *)buffer size:(size_t)size endian:(LLDBByteOrder)endian addressSize:(uint8_t)addressSize error:(LLDBError *__autoreleasing *)error
{
	UNIVERSE_DEBUG_ASSERT(error != nullptr);
	
	lldb::SBError	e{};
	_raw.SetData(e, buffer, size, toCPP(endian), addressSize);
	*error				=	[[LLDBError alloc] initWithCPPObject:e];
}
- (void)append:(LLDBData *)data
{
	UNIVERSE_DEBUG_ASSERT_OBJECT_TYPE(data, LLDBData);
	
	_raw.Append(data->_raw);
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
