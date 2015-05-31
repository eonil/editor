//
//  RFC4627.Unused.swift
//  Monolith
//
//  Created by Hoon H. on 10/21/14.
//
//

import Foundation

//
/////	Implicit serialisations.
//public extension RFC4627 {
//
//	///	Returns `nil` for any errors.
//	///	See `serialise` function for type-mapping informations.
//	public static func deserialise(data:NSData) -> Any? {
//		///	Converting from `Value` tree never raise an error.
//		///	Returning `nil` is a normal regular value for JSON null.
//		func fromValue(v1:Value) -> Any? {
//			func fromArray(a1:[Value]) -> [Any?] {
//				var	a2	=	[] as [Any?]
//				for m1 in a1 {
//					let	m2	=	fromValue(m1)
//					a2.append(m2)
//				}
//				return	a2
//			}
//			func fromObject(o1:[String:Value]) -> [String:Any?] {
//				var	o2	=	[:] as [String:Any?]
//				for (k1,v1) in o1 {
//					let	v2	=	fromValue(v1)
//					o2[k1]	=	v2
//				}
//				return	o2
//			}
//
//			switch v1 {
//				case Value.Null:			return	nil
//				case Value.Boolean(let v1):	return	v1
//				case Value.Number(let v1):
//					switch v1 {
//						case Number.Integer(let v2):	return	v2
//						case Number.Float(let v2):		return	v2
//					}
//				case Value.String(let v1):	return	v1
//				case Value.Array(let v1):	return	fromArray(v1)
//				case Value.Object(let v1):	return	fromObject(v1)
//			}
//		}
//
//		let	v1	=	Value.deserialise(data)
//		return	v1 == nil ? Error.trap() : fromValue(v1!)
//	}
//
//	///
//	///	Type mappings:
//	///
//	///		JSON type			Swift type
//	///		---------			----------
//	///		null				nil*
//	///		boolean				Bool
//	///		number				Int64/Float64**
//	///		string				String
//	///		array				[Any?]***
//	///		object				[String:Any?]***
//	///
//	///	*	Ultimate container type is `Any?`, and it will be treated as JSON null
//	 ///	if the optional state is `nil`.
//	///
//	///	**	All other numeric typed are accepted for JSON number type when encoding,
//	///		but they will become one of `Int64/Float64` types when decoded.
//	///		`UInt64` is not accepted in current implementation due to precision limit.
//	///
//	///	***	Strongly typed homogeneous arrays are not supported. Because it needs tracking
//	///		back of original type, but literally *infinite* number of original type can be
//	///		exist. This cannot be supported until Swift to provide some generalised way to
//	///		access array elements regardless of element type.
//	///
//	public static func serialise(value:Any?) -> NSData? {
//
//		func toValue(v0:Any?) -> Value? {
//			func toArray(a1:[Any?]) -> Value? {
//				var	a2	=	[] as [Value]
//				for m1 in a1 {
//					let	m2	=	toValue(m1)
//					if m2 == nil { return Error.trap() }
//					a2.append(m2!)
//				}
//				return	Value.Array(a2)
//			}
//			func toObject(o1:[String:Any?]) -> Value? {
//				var	o2	=	[:] as [String:Value]
//				for (k1, v1) in o1 {
//					let	v2	=	toValue(v1)
//					if v2 == nil { return Error.trap() }
//					o2[k1]	=	v2!
//				}
//				return	Value.Object(o2)
//			}
//
//			if v0 == nil {
//				return Value.Null
//			} else {
//				let	v1	=	v0!
//				if v1 is Bool { return Value.Boolean(v1 as Bool) }
//
//				if v1 is Int { return Value.Number(RFC4627.Number.Integer(Int64(v1 as Int))) }
//				if v1 is Int8 { return Value.Number(RFC4627.Number.Integer(Int64(v1 as Int8))) }
//				if v1 is Int16 { return Value.Number(RFC4627.Number.Integer(Int64(v1 as Int16))) }
//				if v1 is Int32 { return Value.Number(RFC4627.Number.Integer(Int64(v1 as Int32))) }
//				if v1 is Int64 { return Value.Number(RFC4627.Number.Integer(Int64(v1 as Int64))) }
//
//				if v1 is UInt { return Value.Number(RFC4627.Number.Integer(Int64(v1 as UInt))) }
//				if v1 is UInt8 { return Value.Number(RFC4627.Number.Integer(Int64(v1 as UInt8))) }
//				if v1 is UInt16 { return Value.Number(RFC4627.Number.Integer(Int64(v1 as UInt16))) }
//				if v1 is UInt32 { return Value.Number(RFC4627.Number.Integer(Int64(v1 as UInt32))) }
////				if v1 is UInt64 { return Value.Number(RFC4627.Number.Integer(Int64(v1 as UInt64))) }
//
//				if v1 is Float { return Value.Number(RFC4627.Number.Float(Float64(v1 as Float))) }
//				if v1 is Float32 { return Value.Number(RFC4627.Number.Float(Float64(v1 as Float32))) }
//				if v1 is Float64 { return Value.Number(RFC4627.Number.Float(Float64(v1 as Float64))) }
//
//				if v1 is String { return Value.String(v1 as String) }
//				if v1 is Array<Any?> { return toArray(v1 as [Any?]) }
//				if v1 is Dictionary<String,Any?> { return toObject(v1 as [String:Any?]) }
//
//
//				return	Error.trap("Unsupported type detected in value (\(v1)) while serialising an object tree into JSON.")
//			}
//		}
//
//		let	v2	=	toValue(value)
//		if let v3 = v2 {
//			return	Value.serialise(v3)
//		}
//		return	Error.trap()
//	}
//}
//

