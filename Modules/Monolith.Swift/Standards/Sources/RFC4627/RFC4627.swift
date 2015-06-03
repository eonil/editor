//
//  RFC4627.swift
//  Monolith
//
//  Created by Hoon H. on 10/20/14.
//
//

import Foundation


public struct RFC4627 {
}




public extension RFC4627 {
//	typealias	SwiftString	=	String	///	There should be a better way than this...
	
	///	Explicitly typed representation.
	public enum Value : Equatable {
		case Object(RFC4627.Object)
		case Array(RFC4627.Array)
		case String(Swift.String)
		case Number(RFC4627.Number)
		case Boolean(Bool)
		case Null
		
		public var object:[Swift.String:Value]? {
			get {				
				switch self {
				case let Object(state):		return	state
				default:					return	nil
				}
			}
		}
		public var array:[Value]? {
			get {
				switch self {
				case let Array(state):		return	state
				default:					return	nil
				}
			}
		}
		public var string:Swift.String? {
			get {
				switch self {
				case let String(state):		return	state
				default:					return	nil
				}
			}
		}
		public var number:RFC4627.Number? {
			get {
				switch self {
				case let Number(state):		return	state
				default:					return	nil
				}
			}
		}
		public var boolean:Bool? {
			get {
				switch self {
				case let Boolean(state):	return	state
				default:					return	nil
				}
			}
		}
		
		///	Unexposed intentionally.
		///	Use equality comparison with `nil` instead of.
		///
		///	Example:
		///
		///		var a		=	JSON.Value.Null
		///		var isNull	=	a == nil
		///
		var null:Bool {
			get {
				switch self {
				case let Null:				return	true
				default:					return	false
				}
			}
		}
	}
	
	public typealias	Object	=	[Swift.String:Value]
	public typealias	Array	=	[Value]

	///	Arbitrary precision number container.
	public enum Number : Equatable {
		case Integer(Int64)
		case Float(Double)
//		case Decimal(NSDecimalNumber)		//	Very large sized decimal number.
//		case Arbitrary(expression:String)	//	Arbitrary sized integer/real number expression.
		
		public var integer:Int64? {
			get {
				switch self {
				case let Integer(state):	return	state
				default:					return	nil
				}
			}
		}
		public var float:Double? {
			get {
				switch self {
				case let Float(state):		return	state
				default:					return	nil
				}
			}
		}
	}

}

public extension RFC4627 {
	public static func deserialise(data:NSData) -> JSON.Value? {
		var	e1:NSError?		=	nil
		let	o2:AnyObject?	=	NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &e1)
		
		assert(e1 == nil)
		if e1 != nil { return Error.trap() }
		if o2 == nil { return Error.trap() }
		
		let	o3	=	Converter.convertFromOBJ(o2!)
		return	o3
	}
	
	public static func serialise(value:JSON.Value) -> NSData? {
		return	serialise(value, allowFragment: false)
	}
	///	This does not allow serialisation of fragment. A JSON value must be one
	///	of object or array type. This limitation is due to limitation of `NSJSONSerialization` class.
	static func serialise(value:JSON.Value, allowFragment:Bool) -> NSData? {
		assert(value.object != nil || value.array != nil)
		let	o2:AnyObject	=	Converter.convertFromSwift(value)
		var	e1:NSError?		=	nil
//		let	d3:NSData?		=	NSJSONSerialization.dataWithJSONObject(o2, options: (NSJSONWritingOptions.allZeros) | NSJSONWritingOptions.PrettyPrinted), error: &e1)
		let	d3:NSData?		=	NSJSONSerialization.dataWithJSONObject(o2, options: NSJSONWritingOptions.PrettyPrinted, error: &e1)
		///	I don't think there's any reason to return `nil` from JSON serialisation,
		///	but anyway, OBJC API is written in that way. I just follow it.
		if e1 != nil { return Error.trap() }
		if d3 == nil { return Error.trap() }
		return	d3!
	}
}









///	MARK:
///	MARK:	Literals
///	MARK:
extension RFC4627.Value : NilLiteralConvertible, BooleanLiteralConvertible, IntegerLiteralConvertible, FloatLiteralConvertible, StringLiteralConvertible, ExtendedGraphemeClusterLiteralConvertible, UnicodeScalarLiteralConvertible, ArrayLiteralConvertible, DictionaryLiteralConvertible {
	public typealias	Key		=	Swift.String
	public typealias	Value	=	RFC4627.Value
	public typealias	Element	=	RFC4627.Value
	
	public init(nilLiteral: ()) {
		self	=	Value.Null
	}
	public init(booleanLiteral value: BooleanLiteralType) {
		self	=	Value.Boolean(value)
	}
	public init(integerLiteral value: IntegerLiteralType) {
		self	=	Value.Number(RFC4627.Number.Integer(Int64(value)))
	}
	public init(floatLiteral value: FloatLiteralType) {
		self	=	Value.Number(RFC4627.Number.Float(Float64(value)))
	}
	public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterType) {
		self.init(stringLiteral: value)
	}
	public init(stringLiteral value: StringLiteralType) {
		self	=	Value.String(value)
	}
	public init(unicodeScalarLiteral value: UnicodeScalarType) {
		self.init(stringLiteral: value)
	}
	public init(arrayLiteral elements: Element...) {
		self	=	Value.Array(elements)
	}
	public init(dictionaryLiteral elements: (Key, Value)...) {
		var	o1	=	[:] as [Key:Value]
		for (k,v) in elements {
			o1[k]	=	v
		}
		self	=	Value.Object(o1)
	}
}









///	MARK:
///	MARK:	Collecion Support
///	MARK:

///	`JSON.Value` is treated as an array when you enumerate on it.
///	If underlying value is not an array, it will cause program crash.
///
extension RFC4627.Value : CollectionType {
	
	public var startIndex:Int {
		get {
			precondition(array != nil)
			return	array!.startIndex
		}
	}
	public var endIndex:Int {
		get {
			precondition(array != nil)
			return	array!.endIndex
		}
	}

	public subscript(name:Swift.String) -> Value? {
		get {
			return	object?[name]
		}
	}
	public subscript(index:Int) -> Value {
		get {
			return	array![index]
		}
	}
	
	public func generate() -> IndexingGenerator<[Value]> {
		precondition(array != nil, "Current `Value` does not contain an array.")
		return	array!.generate()
	}
	
	
	
	
	
	
	
}





























































///	MARK:
///	MARK:	Private Stuffs
///	MARK:

///	Converts JSON tree between Objective-C and Swift representations.
private struct Converter {
	typealias	Value	=	JSON.Value
	
	///	Objective-C `nil` is not supported as an input.
	///	Use `NSNull` which is standard way to represent `nil`
	///	in data-structures in Cocoa.
	static func convertFromOBJ(v1:AnyObject) -> Value? {
		assert(v1 is NSObject)
		func convertArray(v1:NSArray) -> Value? {
			var	a2	=	[] as [Value]
			for m1 in v1 {
				///	Must be an OBJC type.
				if (m1 is NSObject) == false { return Error.trap() }
				
				let	m2	=	self.convertFromOBJ(m1 as! NSObject)
				if m2 == nil { return Error.trap() }
				
				a2.append(m2!)
			}
			return	Value.Array(a2)
		}
		func convertObject(v1:NSDictionary) -> Value? {
			var	o2	=	[:] as [String:Value]
			for p1 in v1 {
				let	k1	=	p1.key as? String
				if k1 == nil { return Error.trap() }
				
				let	v2	=	self.convertFromOBJ(p1.value)
				if v2 == nil { return Error.trap() }
				
				o2[k1! as String]	=	v2!
			}
			return	Value.Object(o2)
		}
		
		if v1 is NSNull { return Value.Null }
		if v1 is NSNumber {
			let	v2	=	v1 as! NSNumber
			///	`NSNumber` can be a `CFBoolean` exceptionally if it was created from a boolean value.
			if CFGetTypeID(v2) == CFBooleanGetTypeID() {
				let	v3	=	CFBooleanGetValue(v2) != 0
				return	Value.Boolean(v3)
			}
			if CFNumberIsFloatType(v2) != 0 {
				return	Value.Number(RFC4627.Number.Float(v2.doubleValue))
			} else {
				return	Value.Number(RFC4627.Number.Integer(v2.longLongValue))
			}
		}
		if v1 is NSString { return Value.String(v1 as! NSString as String) }
		if v1 is NSArray { return convertArray(v1 as! NSArray) }
		if v1 is NSDictionary { return convertObject(v1 as! NSDictionary) }
		
		return	Error.trap("Unsupported type. Failed.")
	}
	static func convertFromSwift(v1:Value) -> AnyObject {
		func convertArray(a1:[Value]) -> NSArray {
			let	a2	=	NSMutableArray()
			for m1 in v1.array! {
				let	m2:AnyObject	=	self.convertFromSwift(m1)
				a2.addObject(m2)
			}
			return	a2
		}
		func convertObject(o1:[String:Value]) -> NSDictionary {
			let	o2	=	NSMutableDictionary()
			for (k1, v1) in o1 {
				let	k2				=	k1 as NSString
				let	v2:AnyObject	=	self.convertFromSwift(v1)
				o2.setObject(v2, forKey: k2)
			}
			return	o2
		}
		
		switch v1 {
		case let Value.Null:		return	NSNull()
		case let Value.Boolean(s1):	return	NSNumber(bool: s1)
		case let Value.Number(s1):
			switch s1 {
			case let JSON.Number.Integer(s2):	return	NSNumber(longLong: s2)
			case let JSON.Number.Float(s2):	return	NSNumber(double: s2)
			}
		case let Value.String(s1):	return	s1 as NSString
		case let Value.Array(s1):	return	convertArray(s1)
		case let Value.Object(s1):	return	convertObject(s1)
		}
	}
}











































































///	MARK:
extension RFC4627 {
	struct Test {
		static func run() {
			func tx(c:()->()) {
				c()
			}
			
			
			
			
			
			tx {
				let	a1	=	"{ \"aaa\" : 123 }"
				let	a2	=	a1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
				let	a3	=	JSON.deserialise(a2)!
				
				let	a4	=	JSON.Value.Object([
					"aaa"	:	JSON.Value.Number(RFC4627.Number.Integer(123))
					])
				
				assert(a3 == a4)
			}
			
//			tx {
//				let	a1	=	[
//					"aaa"	:	nil,
//					"bbb"	:	true,
//					"ccc"	:	123,
//					"ddd"	:	456.789,
//					"eee"	:	"Here b a dragon.",
//					"fff"	:	["xxx", "yyy", "zzz"] as [Any?],
//					"ggg"	:	[
//						"f1"	:	"v1",
//						"f2"	:	"v2",
//						"f3"	:	"v3",
//					] as [String:Any?],
//				] as [String:Any?]
//				
//				println(a1["aaa"]!)
//				let	v1	=	a1["aaa"]!
//				assert(a1["aaa"]! == nil)
//				
//				let	a2	=	JSON.serialise(a1)!
//				println(a2)
//				
//				let	a3	=	JSON.deserialise(a2)!
//				println(a3)
//				
//				assert(a3 is [String:Any?])
//			}
			
			tx {
				let	a1	=	[
					"aaa"	:	nil,
					"bbb"	:	true,
					"ccc"	:	123,
					"ddd"	:	456.789,
					"eee"	:	"Here be a dragon.",
					"fff"	:	["xxx", "yyy", "zzz"],
					"ggg"	:	[
						"f1"	:	"v1",
						"f2"	:	"v2",
						"f3"	:	"v3",
						],
					] as Value
				
				println(a1.object!["aaa"]!)
				let	v1	=	a1.object!["aaa"]!
				assert(a1.object!["aaa"]! == nil)
				
				let	a2	=	JSON.serialise(a1)!
				println(a2)
				
				let	a3	=	JSON.deserialise(a2)!
				println(a3)
				
				assert(a3 == a1)
			}
			
			tx {
				let	d1	=	"This is a dynamic text." as Value
				let	a1	=	[
					"aaa"	:	nil,
					"bbb"	:	true,
					"ccc"	:	123,
					"ddd"	:	456.789,
					"eee"	:	d1,
					"fff"	:	[d1, d1, d1],
					"ggg"	:	[
						"f1"	:	d1,
						"f2"	:	d1,
						"f3"	:	d1,
					],
					] as Value
				
				
				let	a2	=	JSON.serialise(a1)!
				println(a2)
				
				let	a3	=	JSON.deserialise(a2)!
				println(a3)
				
				assert(a3 == a1)
				
				println(a3.object!["aaa"]!)
				let	v1	=	a3.object!["aaa"]!
				assert(a3.object!["aaa"]! == nil)
				assert(a3.object!["fff"]! == [d1, d1, d1])
			}

		}
	}
}
























