//
//  Packet.UnitTest.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

extension UnitTest {
	static func testPacketAlgorithms() {
		test1()
	}
	
	private static func test1() {
		func run(f:()->()) {
			f()
		}
		
		run {
			let	bs	=	[UInt8]("abc".utf8)
			let	bs1	=	escapeDataForPacket(bs)
			assert(bs == bs1)
		}
		run {
			let	bs	=	[UInt8]("$#*".utf8)
			let	bs1	=	escapeDataForPacket(bs)
			let	s	=	String(UTF8CodeUnits: bs1)
			assert(s == "}\u{0004}}\u{0003}}\u{000A}")
		}
	}
}

