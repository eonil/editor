//
//  DarkVibrancyAwareTableRowView.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/02/20.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

final class DarkVibrancyAwareTableRowView: NSTableRowView {
//	@objc
//	override var selected:Bool {
//		didSet {
//		}
//	}
	
	override func drawSelectionInRect(dirtyRect: NSRect) {
		if self.window!.keyWindow {
			if let v = self.window!.firstResponder as? NSView {
				if isSuperview(superview: v, ofSubview: self) {
					super.drawSelectionInRect(dirtyRect)
					return
				}
			}
		}
		
//		NSColor.alternateSelectedControlColor().setFill()
		NSColor.secondarySelectedControlColor().colorWithAlphaComponent(0.25).setFill()
		NSRectFill(dirtyRect)
	}
}

private func isSuperview(#superview:NSView?, ofSubview subview:NSView) -> Bool {
	if subview.superview === superview {
		return	true
	} else {
		if subview.superview == nil {
			return	false
		}
		return	isSuperview(superview: superview, ofSubview: subview.superview!)
	}
}


