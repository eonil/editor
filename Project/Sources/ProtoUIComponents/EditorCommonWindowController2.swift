//
//  EditorCommonWindowController2.swift
//  Editor
//
//  Created by Hoon H. on 12/23/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit


///	A window controller which fixes some insane behaviors.
///
///	-	This creates and binds `contentViewController` itself. You can override instantiation of it.
///	-	This sends `windowDidLoad` message at proper timing.
///
///	Do not override any initialiser. Instead, override `windowDidLoad` to setup thigns.
///	This is intentional design to prevent weird OBJC instance replacement behavior.
///
///	IB is unsupported.
@availability(*,deprecated=0)
class EditorCommonWindowController2 : NSWindowController {
	
	///	No support for IB.
	@availability(*,unavailable)
	@availability(*,deprecated=0)
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	@availability(*,unavailable)
	@availability(*,deprecated=0)
	override init(window: NSWindow?) {
		super.init(window: window)
		
		self.loadWindow()
		self.windowDidLoad()
	}

	
	
	
	
	///	Don't call this. Intended for internal use only.
//	@availability(*,unavailable)
	final override func loadWindow() {
		super.window	=	instantiateWindow()
	}
	
	///	Designed to be overridable.
	///	You must call super-implementation.
	override func windowDidLoad() {
		super.windowDidLoad()
		super.window!.contentViewController	=	instantiateContentViewController()
	}
	
	
//	
//	override var windowNibPath:String! {
//		get {
//			return	nil
//		}
//	}
//	override var windowNibName:String! {
//		get {
//			return	nil
//		}
//	}
	
	
	
	
	///	Designed to be overridable.
	func instantiateWindow() -> NSWindow {
		let	w1	=	NSWindow()
		w1.styleMask	|=	NSResizableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask
		return	w1
	}
	
	///	Designed to be overridable.
	func instantiateContentViewController() -> NSViewController {
		return	EmptyViewController(nibName: nil, bundle: nil)!
	}
	
	final override var contentViewController:NSViewController? {
		get {
			return	super.window!.contentViewController
		}
		@availability(*,unavailable)
		set(v) {
			fatalError("You cannot set `contentViewController`. Instead, override `instantiateContentViewController` method to customise its class.")
//			super.contentViewController	=	v
		}
	}
}








private extension EditorCommonWindowController2 {
	
	///	A view controller to suppress NIB searching error.
	@objc
	private class EmptyViewController: NSViewController {
		private override func loadView() {
			super.view	=	NSView();
		}
	}
}

