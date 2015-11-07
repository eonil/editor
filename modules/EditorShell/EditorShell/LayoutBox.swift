//
//  LayoutBox.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/08.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

struct LayoutBox {
	init(_ frame: CGRect) {
		self	=	LayoutBox(frame, _crashOnOverflow)
	}
	private init(_ frame: CGRect, _ filter: (budget: CGFloat, requirement: CGFloat) -> CGFloat) {
		self.frame	=	frame
		self._filter	=	filter
	}







	///

	let frame: CGRect

	func autoshrinkingLayoutBox() -> LayoutBox {
		return	LayoutBox(frame, min)
	}

	func cutMinX(length: CGFloat) -> (minX: LayoutBox, rest: LayoutBox) {
		assert(length > 0)
		let	length1		=	_filter(frame.width, length)
		var	frame1		=	frame
		frame1.size.width	=	length1
		var	frame2		=	frame
		frame2.origin.x		=	frame.minX + length1
		frame2.size.width	-=	length1
		let	cut1		=	LayoutBox(frame1, _filter)
		let	cut2		=	LayoutBox(frame2, _filter)
		return	(cut1, cut2)
	}
	func cutMinY(length: CGFloat) -> (minY: LayoutBox, rest: LayoutBox) {
		assert(length > 0)
		let	length1		=	_filter(frame.height, length)
		var	frame1		=	frame
		frame1.size.height	=	length1
		var	frame2		=	frame
		frame2.origin.y		=	frame.minY + length1
		frame2.size.height	-=	length1
		let	cut1		=	LayoutBox(frame1, _filter)
		let	cut2		=	LayoutBox(frame2, _filter)
		return	(cut1, cut2)
	}
	func cutMaxX(length: CGFloat) -> (maxX: LayoutBox, rest: LayoutBox) {
		assert(length > 0)
		let	length1		=	_filter(frame.width, length)
		var	frame1		=	frame
		frame1.size.width	=	length1
		frame1.origin.x		=	frame.maxX - length1
		var	frame2		=	frame
		frame2.size.width	-=	length1
		let	cut1		=	LayoutBox(frame1, _filter)
		let	cut2		=	LayoutBox(frame2, _filter)
		return	(cut1, cut2)
	}
	func cutMaxY(length: CGFloat) -> (maxY: LayoutBox, rest: LayoutBox) {
		assert(length > 0)
		let	length1		=	_filter(frame.height, length)
		var	frame1		=	frame
		frame1.size.height	=	length1
		frame1.origin.y		=	frame.maxY - length1
		var	frame2		=	frame
		frame2.size.height	-=	length1
		let	cut1		=	LayoutBox(frame1, _filter)
		let	cut2		=	LayoutBox(frame2, _filter)
		return	(cut1, cut2)
	}
	func applyToView(view: NSView) {
		view.frame	=	frame
	}




	private let _filter: (CGFloat, CGFloat) -> CGFloat
}






private func _crashOnOverflow(budget: CGFloat, requirement: CGFloat) -> CGFloat {
	if requirement > budget {
		fatalError()
	}
	return	requirement
}