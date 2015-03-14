//
//  EditorCommonWindowController.swift
//  Editor
//
//  Created by Hoon H. on 11/16/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit


///	A window controller which fixes some insane behaviors.
@availability(*,deprecated=0)
class EditorCommonWindowController : NSWindowController {

	convenience init() {
		self.init(window: nil)
		self.loadWindow()
		self.windowDidLoad()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(window: NSWindow?) {
		super.init(window: window)
	}
	
	override func loadWindow() {
		super.window			=	NSWindow()
		self.window!.styleMask	|=	NSResizableWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask
	}
	
	
	
}

