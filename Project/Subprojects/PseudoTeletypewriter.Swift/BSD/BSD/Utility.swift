//
//  Utility.swift
//  BSD
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

extension NSData {
	func toUInt8Array() -> [UInt8] {
		let	p	=	self.bytes
		let	p1	=	UnsafePointer<UInt8>(p)
		
		var	bs	=	[] as [UInt8]
		for i in 0..<self.length {
			bs.append(p1[i])
		}
		
		return	bs
	}
	func toString() -> String {
		return	NSString(data: self, encoding: NSUTF8StringEncoding)!
	}
	class func fromUInt8Array(bs:[UInt8]) -> NSData {
		var	r	=	nil as NSData?
		bs.withUnsafeBufferPointer { (p:UnsafeBufferPointer<UInt8>) -> () in
			let	p1	=	UnsafePointer<Void>(p.baseAddress)
			r		=	NSData(bytes: p1, length: p.count)
		}
		return	r!
	}
	
	///	Assumes `cCharacters` is C-string.
	class func fromCCharArray(cCharacters:[CChar]) -> NSData {
		precondition(cCharacters.count == 0 || cCharacters[cCharacters.endIndex.predecessor()] == 0)
		var	r	=	nil as NSData?
		cCharacters.withUnsafeBufferPointer { (p:UnsafeBufferPointer<CChar>) -> () in
			let	p1	=	UnsafePointer<Void>(p.baseAddress)
			r		=	NSData(bytes: p1, length: p.count)
		}
		return	r!
	}
}



func debugLog<T>(v:@autoclosure()->T) {
	#if DEBUG
		println("\(v)")
	#endif
}