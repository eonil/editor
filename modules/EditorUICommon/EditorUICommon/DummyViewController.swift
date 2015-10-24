//
//  DummyViewController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

public class DummyViewController: CommonViewController {

	public override func loadView() {
		view		=	CommonView()
	}

	public var backgroundColor: NSColor? {
		get {
			assert(view.layer != nil)
			if let color = view.layer?.backgroundColor {
				return	NSColor(CGColor: color)
			}
			return	nil
		}
		set {
			assert(view.layer != nil)
			view.layer?.backgroundColor	=	newValue?.CGColor
		}
	}
}