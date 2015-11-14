//
//  CommonViewFactory.swift
//  EditorUICommon
//
//  Created by Hoon H. on 2015/11/13.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

public struct CommonViewFactory {
	public static func instantiateOutlineViewForUseInSidebar() -> NSOutlineView {
		let	c	=	NSTableColumn()
		let	v	=	NSOutlineView()
		v.rowSizeStyle	=	NSTableViewRowSizeStyle.Small		//<	This is REQUIRED. Otherwise, cell icon/text layout won't work.
		v.addTableColumn(c)
		v.outlineTableColumn		=	c
		v.headerView			=	nil
		v.backgroundColor		=	NSColor.clearColor()
		v.selectionHighlightStyle	=	.SourceList
		return	v
	}
	public static func instantiateScrollViewForCodeDisplayTextView() -> NSScrollView {
		let	v	=	NSScrollView()
		v.hasHorizontalScroller	=	true
		v.hasVerticalScroller	=	true
		v.drawsBackground	=	false
		return	v
	}
	public static func instantiateTextViewForCodeDisplay() -> NSTextView {
		let	v	=	NSTextView()
		v.verticallyResizable	=	true
		v.horizontallyResizable	=	true
		v.backgroundColor	=	NSColor.controlBackgroundColor()
		v.font			=	_codeFont()
		v.typingAttributes	=	[
			NSFontAttributeName		:	_codeFont(),
			NSForegroundColorAttributeName	:	NSColor.controlTextColor(),
		]
		v.textContainer!.widthTracksTextView	=	false
		v.textContainer!.containerSize		=	CGSize(width: CGFloat.max, height: CGFloat.max)
		return	v
	}
}









private func _codeFont() -> NSFont {
	return	NSFont(name: "Menlo", size: NSFont.systemFontSize())!
}








