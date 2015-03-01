//
//  DarkVibrancyAwareTableRowView.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/02/20.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit



///	This view is tuned to look properly in dark-vibrancy mode in Yosemite.
///	This kind of manual patch applied because Yosemite does not provide
///	proper coloring, and may look somewhat weired in later OS X versions.
///	Patch at the time if you have some such troubles.
public final class DarkVibrancyAwareTableRowView: NSTableRowView {
	
	public override func drawSelectionInRect(dirtyRect: NSRect) {
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


