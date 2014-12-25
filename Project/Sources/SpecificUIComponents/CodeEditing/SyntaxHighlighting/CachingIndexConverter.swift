////
////  CachingIndexConverter.swift
////  Editor
////
////  Created by Hoon H. on 2014/12/26.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//
/////	Converts `String.UnicodeScalarView.Index` into indexes for `NSString` (UTF-16 code-unit indexes).
/////
/////	This provides fast (`< O(n)`) code-unit index search if you query strictly in ascending order.
/////	Otherwise, each query becomes strict `O(n)`.
//struct CachingIndexConverter {
//	typealias	IndexPair	=	(scalarIndex:UIndex, codeUnitIndex:NSInteger)
//	
//	private var targetView	:	String.UnicodeScalarView
//	private var	indexCache	=	[] as [IndexPair]	//	Keep sorted in ascending order.
//	
//	init(targetView:String.UnicodeScalarView) {
//		self.targetView	=	targetView
//	}
//	
//	///	Returns `startIndex` if nothing found in cache.
//	func largestIndexLessThanOrEqualToIndexInCache(index:UIndex) -> IndexPair {
//		for p in indexCache.reverse() {
//			if p.scalarIndex <= index {
//				return	p
//			}
//		}
//		return	IndexPair(scalarIndex: targetView.startIndex, codeUnitIndex: 0)
//	}
//	func codeUnitCountInRange(r:URange) -> NSInteger {
//		//	`String` is `NSStirng` and `NSString` is likely to make subrange view instead of copying the content.
//		return	(String(targetView[r]) as NSString).length
//	}
//	//	mutating func queryUTF16CodeUnitIndexWithScalarIndex(index:UIndex) -> NSInteger {
//	//		let p	=	largestIndexLessThanOrEqualToIndexInCache(index)
//	//		let	r	=	URange(start: p.scalarIndex, end: index)
//	//		let	c	=	codeUnitCountInRange(r)
//	//		return	p.codeUnitIndex + c
//	//	}
//	mutating func queryUTF16CodeUnitIndexWithScalarIndex(index:UIndex) -> NSInteger {
//		return	(String(targetView[targetView.startIndex..<index]) as NSString).length
//	}
//	mutating func query(range:URange) -> NSRange {
//		let	b	=	queryUTF16CodeUnitIndexWithScalarIndex(range.startIndex)
//		let	e	=	queryUTF16CodeUnitIndexWithScalarIndex(range.endIndex)
//		return	NSRange(location: b, length: e-b)
//	}
//}
