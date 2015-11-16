//
//  PaneSplitView.swift
//  EditorUICommon
//
//  Created by Hoon H. on 2015/11/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit



public class PaneSplitView: NSSplitView {

	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}






	///

	public override var dividerColor: NSColor {
		get {
//			return	NSColor.redColor()
			return	_dividerColor
		}
		set {
			_dividerColor	=	newValue
			needsLayout	=	true
			needsDisplay	=	true
		}
	}
	public override var dividerThickness: CGFloat {
		get {
			return	_dividerThickness
		}
		set {
			_dividerThickness	=	newValue
			needsLayout	=	true
			needsDisplay	=	true
		}
	}

	///

	private var	_dividerColor		:	NSColor	=	NSColor.gridColor()
	private var	_dividerThickness	:	CGFloat	=	0
}




