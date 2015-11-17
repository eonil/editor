//
//  CommonWindowController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel

/// Fixes some bugs in AppKit.
/// Provides automatic shell propagations through view and view-controllers.
///
public class CommonWindowController: NSWindowController {

	public init() {
		_inInit	=	true
		super.init(window: _TrackingWindow())
		_inInit	=	false
	}
	@available(*,unavailable)
	public override init(window: NSWindow?) {
		super.init(window: window)
		assert(_inInit == true, "Do not call this initializer directly. Use `init()` that is a designated initializer.")
	}
	@available(*,unavailable)
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		assert(_inInit == true, "Do not call this initializer directly. Use `init()` that is a designated initializer.")
	}

	///

	@available(*, unavailable)
	public override func loadWindow() {
		window	=	NSWindow()
	}
	@available(*, unavailable)
	public override func windowWillLoad() {
		super.windowWillLoad()
	}
	@available(*, unavailable)
	public override func windowDidLoad() {
		super.windowDidLoad()
	}

	public override var contentViewController: NSViewController? {
		get {
			return	super.contentViewController
		}
		set {
			assert(newValue is CommonViewController)
			super.contentViewController	=	newValue as! CommonViewController
		}
	}

	///

	private var	_inInit	=	false
}

















private class _TrackingWindow: NSWindow {
	deinit {

	}
}

//private class CheckingWindow: NSWindow {
//	private override func becomeMainWindow() {
//		super.becomeMainWindow()
//		func app() -> NSApplication {
//			return	NSApplication.sharedApplication()
//		}
//		assert(app().active == false || app().hidden == true || app().mainWindow === self)
//	}
//	private override func resignMainWindow() {
//		super.resignMainWindow()
//		func app() -> NSApplication {
//			return	NSApplication.sharedApplication()
//		}
//		assert(app().active == false || app().hidden == true || app().mainWindow !== self)
//	}
//}


class CommonUIWindow: NSWindow {
}


