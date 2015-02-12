//
//  ShelfView.swift
//  Editor
//
//  Created by Hoon H. on 2015/02/04.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit




///	Aligns subviews horizontally in order of them.
///	Size of each items will be retrieved by calling `sizeThatFits(CGSize.zeroSize)`.
///	This does not support auto-layout and an autolayout barrier.
///
///	Requirements
///	------------
///	-	All subviews must be `NSControl`.
///	-	This control must be equal or larger than sum of all subviews. (that can be resolved using `minimumSize`).
///		You are responsible to guarantee this size requirement. Do not resize smaller than minimum size.
///
final class ShelfView: NSControl {
	var minimumSize:CGSize {
		get {
			var	szs	=	[] as [CGSize]
			for v in (subviews as! [NSControl]) {
				let	sz	=	v.sizeThatFits(CGSize.zeroSize)
				szs.append(sz)
			}
			
			let	sumW	=	szs.map({ v in v.width }).reduce(0, combine: +)
			let	maxH	=	szs.map({ v in v.height }).reduce(0, combine: max)
			let	totalsz	=	CGSize(width: sumW, height: maxH)
			return	totalsz
		}
	}
	
	override func resizeSubviewsWithOldSize(oldSize: NSSize) {
		super.resizeSubviewsWithOldSize(oldSize)
		precondition(self.bounds.size.width > self.minimumSize.width && self.bounds.size.height > self.minimumSize.height, "Size of this control must be equal to or larger than `minimumSize`.")
		
		let	tsz	=	minimumSize
		
		let	b	=	self.bounds
		let	c	=	CGPoint(x: b.midX, y: b.midY)
		let	p	=	c - (tsz.toPoint()/2)
		
		for v in (subviews as! [NSControl]) {
			let	f	=	v.sizeThatFits(CGSize.zeroSize)
			let	f1	=	CGRect(origin: p, size: f)
			v.frame	=	f1
		}
	}
	
	override func sizeThatFits(size: NSSize) -> NSSize {
		let	msz	=	minimumSize
		return	CGSize(width: max(size.width, msz.width), height: max(size.height, msz.height))
	}
	
	override var intrinsicContentSize:CGSize {
		get {
			return	sizeThatFits(CGSize.zeroSize)
		}
	}
}
















extension CGPoint {
	func toSize() -> CGSize {
		return	CGSize(width: self.x, height: self.y)
	}
}
extension CGSize {
	func toPoint() -> CGPoint {
		return	CGPoint(x: self.width, y: self.height)
	}
}
private func * (left:CGPoint, right:CGPoint) -> CGPoint {
	return	CGPoint(x: left.x * right.x, y: left.y * right.y)
}
private func / (left:CGPoint, right:CGPoint) -> CGPoint {
	return	CGPoint(x: left.x / right.x, y: left.y / right.y)
}
private func / (left:CGPoint, right:CGFloat) -> CGPoint {
	return	CGPoint(x: left.x / right, y: left.y / right)
}
private func - (left:CGPoint, right:CGPoint) -> CGPoint {
	return	CGPoint(x: left.x - right.x, y: left.y - right.y)
}




