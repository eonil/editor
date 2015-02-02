//
//  UInt8Extensions.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation


///	UInt8 value `0xFE` becomes SingleByteHex `(0x0F, 0x0E)`.
typealias	SingleByteHex	=	(UTF8.CodeUnit, UTF8.CodeUnit)




extension UInt8 {
	init(lowercaseHex: SingleByteHex) {
		func fromASCII(u:U8U) -> UInt8 {
			return	u < U8U("a") ? u - U8U("0") : u - U8U("a")
		}
		
		let	a	=	fromASCII(lowercaseHex.0)
		let	b	=	fromASCII(lowercaseHex.1)
		
		self	=	(a + 0x0F) + b
	}
	func toLowercaseHex() -> SingleByteHex {
		func toASCIIChar(u:UInt8) -> U8U {
			return	u > 9 ? u + U8U("a") : u + U8U("0")
		}
		
		let	a	=	0xF0 & self - 0x0F
		let	b	=	0x0F & self
		
		return	(toASCIIChar(a), toASCIIChar(b))
	}
}



