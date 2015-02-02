//
//  RunLengthEncoding.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

struct RunLengthEncoding {
//	static func encode(data:[UInt8]) -> [UInt8] {	
//	}
	static func decode(data:[UInt8]) -> [UInt8] {
		return	[UInt8](RLEDecodingGenerator(data.generate()))
	}
}





private func RLEDecodingGenerator<G:GeneratorType where G.Element == UInt8>(g:G) -> GeneratorOf<UInt8> {
	var	g1			=	g
	var	latestUnit	=	nil as UInt8?
	var	repCounter	=	UInt8(0)
	return	GeneratorOf {
		while let u = g1.next() {
			if repCounter > 0 {
				repCounter--
				return	latestUnit!
			}
			if u == U8U("*") {
				let	u1	=	g1.next()!
				precondition(u1 >= 29)
				let	n	=	u1 - 29
				precondition(n >= 3)
				precondition(n < 126)
				repCounter	=	n - 1
				return	latestUnit!
				
			} else {
				latestUnit	=	u
				return	u
			}
		}
		return	nil
	}
}



//private struct RLEParser {
//	var	latestUnit	=	nil as UInt8?
//	var	phase		=	Phase.Normal
//	var	onUnit		=	{ u in } as (UInt8)->()
//	
//	mutating func push(u:UInt8) {
//		switch phase {
//		case .Normal:
//			if u == UTF8.CodeUnit("*") {
//				phase	=	Phase.RepetitionCount
//			} else {
//				latestUnit	=	u
//				onUnit(u)
//			}
//			
//		case .RepetitionCount:
//			precondition(latestUnit != nil)
//			precondition(u >= 29)
//			let	n	=	u - 29
//			precondition(n >= 3)
//			precondition(n < 126)
//			for i in 0..<n {
//				onUnit(latestUnit!)
//			}
//			latestUnit	=	nil
//			phase		=	Phase.Normal
//		}
//		if u == UTF8.CodeUnit("*") {
//			
//		} else {
//		}
//	}
//	
//	enum Phase {
//		case Normal
//		case RepetitionCount
//	}
//}






