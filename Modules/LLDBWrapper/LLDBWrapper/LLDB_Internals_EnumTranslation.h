//
//  LLDB_Internals_EnumTranslation.h
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

#pragma once
#import <LLDB/LLDB.h>
#import <LLDB/lldb-enumerations.h>
#import "LLDBEnums.h"



/*
 All translation functions in this file must be reviewd and may be re-written to provide
 explicit mapping.
 */



static inline auto
fromCPP(lldb::StateType v) -> LLDBStateType {
	return	(LLDBStateType)v;
}
static inline auto
toCPP(LLDBStateType v) -> lldb::StateType {
	return	(lldb::StateType)v;
}






static inline auto
fromCPP(lldb::StopReason v) -> LLDBStopReason {
	return	(LLDBStopReason)v;
}
static inline auto
toCPP(LLDBStopReason v) -> lldb::StopReason {
	return	(lldb::StopReason)v;
}




static inline auto
fromCPP(lldb::DynamicValueType v) -> LLDBDynamicValueType {
	return	(LLDBDynamicValueType)v;
}
static inline auto
toCPP(LLDBDynamicValueType v) -> lldb::DynamicValueType {
	return	(lldb::DynamicValueType)v;
}




static inline auto
fromCPP(lldb::ValueType v) -> LLDBValueType {
	return	(LLDBValueType)v;
}
static inline auto
toCPP(LLDBValueType v) -> lldb::ValueType {
	return	(lldb::ValueType)v;
}












static inline auto
fromCPP(lldb::ErrorType v) -> LLDBErrorType {
	return	(LLDBErrorType)v;
}
static inline auto
toCPP(LLDBErrorType v) -> lldb::ErrorType {
	return	(lldb::ErrorType)v;
}









static inline auto
fromCPP(lldb::AddressClass v) -> LLDBAddressClass {
	return	(LLDBAddressClass)v;
}
static inline auto
toCPP(LLDBAddressClass v) -> lldb::AddressClass {
	return	(lldb::AddressClass)v;
}










static inline auto
fromCPP(lldb::ByteOrder v) -> LLDBByteOrder {
	return	(LLDBByteOrder)v;
}
static inline auto
toCPP(LLDBByteOrder v) -> lldb::ByteOrder {
	return	(lldb::ByteOrder)v;
}










static inline auto
fromCPP(lldb::SectionType v) -> LLDBSectionType {
	return	(LLDBSectionType)v;
}
static inline auto
toCPP(LLDBSectionType v) -> lldb::SectionType {
	return	(lldb::SectionType)v;
}














static inline auto
fromCPP(lldb::Format v) -> LLDBFormat {
	return	(LLDBFormat)v;
}
static inline auto
toCPP(LLDBFormat v) -> lldb::Format {
	return	(lldb::Format)v;
}















