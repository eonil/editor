//
//  Numerics.swift
//  Text
//
//  Created by Hoon H. on 10/18/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


///	Simple value scanner from text representation.
///	All methods require full consumption of source string.
///	This is actually a thin wrapper of `NSScanner`.
struct Scanner {
	static func scanInt(expression:String) -> Int? {
		return	scan(expression, 0 as Int, { s, p in return s.scanInteger(p) }, true)
	}
	static func scanUInt(expression:String) -> UInt? {
		let	v1	=	scanUInt64(expression)
		if let v2 = v1 {
			if v2 >= UInt64(UInt.min) && v2 <= UInt64(UInt.max) {
				return	UInt(v2)
			}
		}
		return	nil
	}
	static func scanInt32(expression:String) -> Int32? {
		return	scan(expression, 0 as Int32, { s, p in return s.scanInt(p) }, true)
	}
	static func scanUInt32(expression:String) -> UInt32? {
		let	v1	=	scanUInt64(expression)
		if let v2 = v1 {
			if v2 >= UInt64(UInt32.min) && v2 <= UInt64(UInt32.max) {
				return	UInt32(v2)
			}
		}
		return	nil
	}
	static func scanInt64(expression:String) -> Int64? {
		return	scan(expression, 0 as Int64, { s, p in return s.scanLongLong(p) }, true)
	}
	static func scanUInt64(expression:String) -> UInt64? {
		return	scan(expression, 0 as UInt64, { s, p in return s.scanUnsignedLongLong(p) }, true)
	}
	static func scanFloat(expression:String) -> Float? {
		return	scan(expression, 0 as Float, { s, p in return s.scanFloat(p) }, true)
	}
	static func scanDouble(expression:String) -> Double? {
		return	scan(expression, 0 as Double, { s, p in return s.scanDouble(p) }, true)
	}
	
	////
	
	private static func scan<T>(expression:String, _ initialValue:T, _ invoke:(scanner:NSScanner, pointer:UnsafeMutablePointer<T>)->Bool, _ requireFullConsumption:Bool) -> T? {
		let	s1	=	NSScanner(string: expression)
		let	p1	=	UnsafeMutablePointer<T>.alloc(1)
		p1.initialize(initialValue)
		let	r1	=	invoke(scanner: s1, pointer: p1)
		let	v1	=	p1.memory
		p1.destroy(1)
		p1.dealloc(1)
		let	e1	=	requireFullConsumption ? s1.atEnd : true
		return	r1 && e1 ? v1 : nil
	}
}

