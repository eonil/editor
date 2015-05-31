//
//  Value.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 9/15/14.
//
//

import Foundation




public typealias	Binary	=	Blob

///	We don't use Swift `nil` to represent SQLite3 `NULL` because it
///	makes program more complex.
///
///	https://www.sqlite.org/datatype3.html
public enum Value : Equatable, Hashable, Printable, NilLiteralConvertible, IntegerLiteralConvertible, FloatLiteralConvertible, StringLiteralConvertible {
	case Null
	case Integer(Int64)
	case Float(Double)
	case Text(String)
	case Blob(Binary)
}

public extension Value {
}

public extension Value {
	public var hashValue:Int {
		get {
			switch self {
			case Null:				return	0
			case let Integer(s):	return	s.hashValue
			case let Float(s):		return	s.hashValue
			case let Text(s):		return	s.hashValue
			case let Blob(s):		return	s.hashValue
			}
		}
	}
}

public extension Value {
	public init(nilLiteral: ()) {
		self	=	Value.Null
	}

	public init(integerLiteral value: Int64) {
		self	=	Integer(value)
	}
//	public init(integerLiteral value: Int) {
//		precondition(IntMax(value) <= IntMax(Int64.max))
//		self	=	Integer(Int64(value))
//	}

	public init(floatLiteral value: Double) {
		self	=	Float(value)
	}
	public init(stringLiteral value: String) {
		self	=	Text(value)
	}
	public init(extendedGraphemeClusterLiteral value: String) {
		self	=	Text(value)
	}
	public init(unicodeScalarLiteral value: String) {
		self	=	Text(value)
	}
}

public extension Value {
	public var description:String {
		get {
			switch self {
			case let Null(s):		return	"NULL"
			case let Integer(s):	return	"INTEGER(\(s))"
			case let Float(s):		return	"FLOAT(\(s))"
			case let Text(s):		return	"TEXT(\(s))"
			case let Blob(s):		return	"BLOB(~~~~)"
//			default:				fatalError("Unsupported value case.")
			}
		}
	}
}


public func == (l:Value, r:Value) -> Bool {
	switch (l,r) {
	case let (Value.Null, Value.Null):				return	true
	case let (Value.Integer(a), Value.Integer(b)):	return	a == b
	case let (Value.Float(a), Value.Float(b)):		return	a == b
	case let (Value.Text(a), Value.Text(b)):		return	a == b
	case let (Value.Blob(a), Value.Blob(b)):		return	a == b
	default:										return	false
	}
}

//public func == (l:Value, r:()?) -> Bool {
//	return	l == Value.Null && r == nil
//}
//
//public func == (l:Value, r:Int) -> Bool {
//	return	l == Int64(r)
//}
//public func == (l:Value, r:Int64) -> Bool {
//	if let v2 = l.integer { return v2 == r }
//	return	false
//}
//public func == (l:Value, r:Double) -> Bool {
//	if let v2 = l.float { return v2 == r }
//	return	false
//}
//public func == (l:Value, r:String) -> Bool {
//	if let v2 = l.text { return v2 == r }
//	return	false
//}
//public func == (l:Value, r:Binary) -> Bool {
//	if let v2 = l.blob { return v2 == r }
//	return	false
//}

public extension Value {
//	init(){
//		self	=	Value.Null
//	}
	public init(_ v:Int64?) {
		self	=	v == nil ? Null : Integer(v!)
	}
	public init(_ v:Double?) {
		self	=	v == nil ? Null : Float(v!)
	}
	public init(_ v:String?) {
		self	=	v == nil ? Null : Text(v!)
	}
	public init(_ v:Binary?) {
		self	=	v == nil ? Null : Blob(v!)
	}
	
	public var null:Bool {
		get {
			return	self == Value.Null
//			switch self {
//			case let Null:			return	true
//			default:				return	false
//			}
		}
	}
	public var integer:Int64? {
		get {
			switch self {
			case let Integer(s):	return	s
			default:				return	nil
			}
		}
	}
	public var float:Double? {
		get {
			switch self {
			case let Float(s):		return	s
			default:				return	nil
			}
		}
	}
	public var text:String? {
		get {
			switch self {
			case let Text(s):		return	s
			default:				return	nil
			}
		}
	}
	public var blob:Binary? {
		get {
			switch self {
			case let Blob(s):		return	s
			default:				return	nil
			}
		}
	}
}

























//
//public typealias	Value	=	AnyObject				///<	Don't use `Any`. Currently, it causes many subtle unknown problems.
//
//
//
//
////
////public typealias	FieldList	=	[Value]				///<	The value can be one of these types;	`Int`, `Double`, `String`, `Blob`. A field with NULL will not be stored.
////public typealias	Record		=	[String:Value]
////
////struct RowList
////{
////	let	columns:[String]
////	let	items:[FieldList]
////}
//
//
//
//
//
////typealias	Integer	=	Int64
//
/////	64-bit signed integer class type.
/////	Defined to provide conversion to AnyObject.
/////	(Swift included in Xcode 6.0.1 does not support this conversion...)
//public class Integer : Printable//, SignedIntegerType, SignedNumberType
//{
//	public init(_ number:Int64)
//	{
//		self.number	=	number
//	}
//	
//	
//	public var description:String
//	{
//		get
//		{
//			return	number.description
//		}
//	}
//	
////	public var hashValue:Int
////	{
////		get
////		{
////			return	number.hashValue
////		}
////	}
////	
////	public var arrayBoundValue:Int64.ArrayBound
////	{
////		get
////		{
////			return	number.arrayBoundValue
////		}
////	}
////	public func toIntMax() -> IntMax
////	{
////		return	number.toIntMax()
////	}
////	
////	public class func from(x: IntMax) -> Integer
////	{
////		return	Integer(Int64.from(x))
////	}
//
//	let	number:Int64
//}
//
//extension Int64
//{
//	init(_ integer:Integer)
//	{
//		self.init(integer.number)
//	}
//}



///	Represents BLOB.
public class Blob: Hashable
{
	init(address:UnsafePointer<()>, length:Int) {
		precondition(address != nil)
		precondition(length >= 0)
		
		value	=	NSData(bytes: address, length: length)
	}
	
	public var hashValue:Int {
		get {
			return	value.hashValue
		}
	}
	
	var length:Int
	{
		get
		{
			return	value.length
		}
	}
	
	var address:UnsafePointer<()>
	{
		get
		{
			return	value.bytes
		}
	}
	
	
	
	
	
	private init(value:NSData)
	{
		self.value	=	value
	}
	
	private let	value:NSData
}

public func == (l:Blob, r:Blob) -> Bool {
	return	l.value == r.value
}










