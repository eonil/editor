////
////  ShelfView.swift
////  Editor
////
////  Created by Hoon H. on 2015/02/04.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//
//
//
//
//
/////	DEPRECATED. USE `NSStackView` instead of.
/////	
/////
/////
/////	Aligns subviews horizontally in order of them.
/////	This does not support auto-layout and behaves as an autolayout barrier.
/////
/////	-	All subviews must valid intrinsic content size.
/////	-	Layout does not change bounds/frame of this view. Just reposition subviews.
/////	-	Call `sizeToFit` to resize this view by content. Resize will be performed 
/////		around at zero-point.
/////
//
//@availability(*,deprecated=0)
//public final class ShelfView: NSControl {
//	public var minimumSize:CGSize {
//		get {
//			var	szs	=	[] as [CGSize]
//			for v in (subviews as! [NSControl]) {
//				let	sz	=	v.sizeThatFits(CGSize.zeroSize)
//				szs.append(sz)
//			}
//			
//			let	sumW	=	szs.map({ v in v.width }).reduce(0, combine: +)
//			let	maxH	=	szs.map({ v in v.height }).reduce(0, combine: max)
//			let	totalsz	=	CGSize(width: sumW, height: maxH)
//			return	totalsz
//		}
//	}
//	
//	public override func resizeSubviewsWithOldSize(oldSize: NSSize) {
//		super.resizeSubviewsWithOldSize(oldSize)
//		
//		let	tsz	=	minimumSize
//		
//		let	b	=	self.bounds
//		let	c	=	CGPoint(x: b.midX, y: b.midY)
//		let	p	=	c - (tsz.toPoint()/2)
//		
//		for v in (subviews as! [NSControl]) {
//			let	sz	=	v.intrinsicContentSize
//			assert(sz.width != NSViewNoInstrinsicMetric)
//			assert(sz.height != NSViewNoInstrinsicMetric)
//			
//			let	f	=	v.sizeThatFits(CGSize.zeroSize)
//			let	f1	=	CGRect(origin: p, size: f)
//			v.frame	=	f1
//		}
//		
////		assert(self.bounds.size.width > self.minimumSize.width && self.bounds.size.height > self.minimumSize.height, "Size of this control must be equal to or larger than `minimumSize`.")
//	}
//	
//	public override func sizeThatFits(size: NSSize) -> NSSize {
//		let	msz	=	minimumSize
//		return	CGSize(width: max(size.width, msz.width), height: max(size.height, msz.height))
//	}
//	public override func sizeToFit() {
//		let	sz		=	minimumSize
//		let	f		=	self.frame
//		let	f1		=	CGRect(x: f.origin.x, y: f.origin.y, width: sz.width, height: sz.height)
//		self.frame	=	f1
//	}
//	
//	public override var intrinsicContentSize:CGSize {
//		get {
//			return	minimumSize
//		}
//	}
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//extension CGPoint {
//	func toSize() -> CGSize {
//		return	CGSize(width: self.x, height: self.y)
//	}
//}
//extension CGSize {
//	func toPoint() -> CGPoint {
//		return	CGPoint(x: self.width, y: self.height)
//	}
//}
//private func * (left:CGPoint, right:CGPoint) -> CGPoint {
//	return	CGPoint(x: left.x * right.x, y: left.y * right.y)
//}
//private func / (left:CGPoint, right:CGPoint) -> CGPoint {
//	return	CGPoint(x: left.x / right.x, y: left.y / right.y)
//}
//private func / (left:CGPoint, right:CGFloat) -> CGPoint {
//	return	CGPoint(x: left.x / right, y: left.y / right)
//}
//private func - (left:CGPoint, right:CGPoint) -> CGPoint {
//	return	CGPoint(x: left.x - right.x, y: left.y - right.y)
//}
//
//
//
//
