//
//  CustomizableTextSegmentedControl.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/13.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

class CustomizableTextSegmentedControl: NSSegmentedControl {
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		_ready	=	true
		super.setCell(_DarkModeTextSegmentedCell())
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		_ready	=	true
		super.setCell(_DarkModeTextSegmentedCell())
	}
	
	@availability(*,unavailable)
	override func setCell(aCell: NSCell?) {
		precondition(_ready == false || aCell is _DarkModeTextSegmentedCell)
		super.setCell(aCell)
	}
	
	var	colors		:	(normal: NSColor, selection: NSColor)? {
		didSet {
			(cell() as! _DarkModeTextSegmentedCell).colors	=	colors
		}
	}
	
	///
	
	private var	_ready	=	false
}


private class _DarkModeTextSegmentedCell: NSSegmentedCell {
	
	var	colors		:	(normal: NSColor, selection: NSColor)?
	
	override func drawSegment(segment: Int, inFrame frame: NSRect, withView controlView: NSView) {
		if let _ = colors {
			_drawWithCustomColors(segment, frame: frame)
		} else {
			super.drawSegment(segment, inFrame: frame, withView: controlView)
		}
	}
	
	private func _drawWithCustomColors(segment: Int, frame: CGRect) {
		let	str	=	labelForSegment(segment)!
		
		let	sel	=	isSelectedForSegment(segment)
		let	color	=	sel ? colors!.selection : colors!.normal

		let	style	=	NSMutableParagraphStyle()
		style.alignment	=	NSTextAlignment.CenterTextAlignment
		
		let	attrs	=	[
			NSParagraphStyleAttributeName		:	style,
			NSFontAttributeName			:	font!,
			NSForegroundColorAttributeName		:	color,
			] as [NSObject: AnyObject]
		
		let	text	=	NSAttributedString(string: str, attributes: attrs)
		let	sz	=	text.size
		let	x	=	floor(frame.midX - (sz.width / 2))
		let	y	=	floor(frame.midY - (sz.height / 2))
		let	w	=	ceil(sz.width)
		let	h	=	ceil(sz.height)
		let	frame1	=	CGRect(x: x, y: y, width: w, height: h)
		text.drawInRect(frame1)
	}
}




