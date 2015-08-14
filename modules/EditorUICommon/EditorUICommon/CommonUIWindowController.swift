//
//  CommonUIWindowController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel

///	Fixes some bugs in AppKit.
///	Provides automatic shell propagations through view and view-controllers.
///
public class CommonUIWindowController: NSWindowController, ModelConsumerNodeType {

	public init() {
		_inInit	=	true
		super.init(window: NSWindow())
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

	public weak var model: Model? {
		get {
			return	_modelConsumerNode.model
		}
		set {
			_modelConsumerNode.model	=	newValue
		}
	}
	public func registerShellConsumer(consumer: ModelConsumerProtocol) {
		_modelConsumerNode.registerShellConsumer(consumer)
	}
	public func deregisterShellConsumer(consumer: ModelConsumerProtocol) {
		_modelConsumerNode.deregisterShellConsumer(consumer)
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
			assert(newValue is CommonUIController)
			if let newValue = newValue as? CommonUIController {
				super.contentViewController	=	newValue
			}
		}
	}

	///

	private let	_modelConsumerNode	=	ModelConsumerNode()
	private var	_inInit	=	false
}






















class CommonUIWindow: NSWindow {
}


