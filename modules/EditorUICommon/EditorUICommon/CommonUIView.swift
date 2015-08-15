//
//  CommonUIView.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel

///
///	-	Always uses layer.
///
///	Shell Propagation
///	-----------------
///	`shell` will automatically be propagated to subviews that are subclass of
///	`CommonUIView`. If a subview is not a subclass of `CommonUIView` class, 
///	automatic propagation won't work for the subview. You still can route
///	shell object to the view yourself manually.
///
public class CommonUIView: CommonView {

	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		super.wantsLayer	=	true
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		super.wantsLayer	=	true
	}
	deinit {
		assert(_isInstalled == false)
	}

	///

	public func installSubcomponents() {
		assert(_supercallCheckFlag == false)
		_supercallCheckFlag	=	true
	}
	public func deinstallSubcomponents() {
		assert(_supercallCheckFlag == false)
		_supercallCheckFlag	=	true
	}
	public func layoutSubcomponents() {
		assert(_supercallCheckFlag == false)
		_supercallCheckFlag	=	true
	}

	///

	@available(*, unavailable)
	public override var wantsLayer: Bool {
		get {
			return	super.wantsLayer
		}
		set {
			assert(newValue == true, "This class always use a layer, so you cannot set this property to `false`.")
			super.wantsLayer	=	newValue
		}
	}
	public override var layer: CALayer? {
		get {
			return	super.layer
		}
		set {
			assert(newValue != nil, "This class always use a layer, so you cannot set this property to `nil`.")
			super.layer	=	newValue
		}
	}
	public override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		if window != nil {
			_install()
			needsLayout	=	true
		}
	}
	public override func viewWillMoveToWindow(newWindow: NSWindow?) {
		if window != nil {
			_deinstall()
		}
		super.viewWillMoveToWindow(newWindow)
	}
	public override func resizeSubviewsWithOldSize(oldSize: NSSize) {
		super.resizeSubviewsWithOldSize(oldSize)
		_layout()
	}

	public override func didAddSubview(subview: NSView) {
		super.didAddSubview(subview)
	}
	public override func willRemoveSubview(subview: NSView) {
		super.willRemoveSubview(subview)
	}

	///

	private var	_isInstalled		=	false
	private var	_supercallCheckFlag	=	false

	private func _install() {
		assert(_isInstalled == false)

		assert(_supercallCheckFlag == false)
		installSubcomponents()
		assert(_supercallCheckFlag == true)
		_supercallCheckFlag	=	false

		_isInstalled		=	true

		_layout()
	}
	private func _deinstall() {
		assert(_isInstalled == true)

		assert(_supercallCheckFlag == false)
		deinstallSubcomponents()
		assert(_supercallCheckFlag == true)
		_supercallCheckFlag	=	false

		_isInstalled		=	false
	}
	private func _layout() {
		assert(_supercallCheckFlag == false)
		layoutSubcomponents()
		assert(_supercallCheckFlag == true)
		_supercallCheckFlag	=	false
	}
}



















