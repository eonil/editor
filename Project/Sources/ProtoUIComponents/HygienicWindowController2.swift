//
//  HygienicWindowController2.swift
//  Editor
//
//  Created by Hoon H. on 12/23/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit


///	A window controller which fixes some insane behaviors.
class HygienicWindowController2 : NSWindowController {
	
	func instantiateWindow() -> NSWindow {
		let	w1	=	NSWindow()
		w1.styleMask	|=	NSResizableWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask
		return	w1
	}
	func instantiateContentViewController() -> NSViewController {
		return	NSViewController()
	}
	
	override var contentViewController:NSViewController? {
		get {
			return	super.window!.contentViewController
		}
		@availability(*,unavailable)
		set(v) {
			fatalError("You cannot set `contentViewController`. Instead, override `instantiateContentViewController` method to customise its class.")
			super.contentViewController	=	v
		}
	}
	
	override init() {
		super.init()
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
		super.window	=	instantiateWindow()
	}
	override func windowDidLoad() {
		super.windowDidLoad()
		super.window!.contentViewController	=	instantiateContentViewController()
	}
	
	
	
}

