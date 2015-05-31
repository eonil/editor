////
////  SavepointNameGenerator.swift
////  EonilSQLite3
////
////  Created by Hoon H. on 11/2/14.
////
////
//
//import Foundation
//
//struct SavepointNameGenerator {
//	///	Maximum resolution is `1/(Int.max-1)` per a second.
//	///	That's the hard limit of this algorithm. If you need something
//	///	better, you have to make and specify your own generator on initializer
//	///	of `Connection` class.
//	static func uniqueAtomicUnitName() -> String {
//		struct deduplicator {
//			var	lastSeed			=	0
//			var	duplicationCount	=	0
//			
//			mutating func stepOne() -> String {
//				let	t1	=	Int(NSDate().timeIntervalSince1970)
//				if t1 == lastSeed {
//					precondition(duplicationCount < Int.max)
//					duplicationCount	+=	1
//				} else {
//					lastSeed			=	t1
//					duplicationCount	=	0
//				}
//				return	"eonil__sqlite3__\(lastSeed)__\(duplicationCount)"
//			}
//			
//			static var	defaultInstance	=	deduplicator()
//		}
//		
//		return	deduplicator.defaultInstance.stepOne()
//	}
//}