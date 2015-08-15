//
//  WorkspaceWindowUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel
import EditorUICommon

public final class WorkspaceWindowUIController: CommonUIWindowController, SessionProtocol {

	///	Will be set by upper level node.
	public weak var model: WorkspaceModel? {
		didSet {
			_tools.model	=	model
			_div.model	=	model
		}
	}
	
	public func run() {
		assert(model != nil)

		_div.view.frame			=	CGRect(origin: CGPoint.zeroPoint, size: _getMinSize())
		window!.contentViewController	=	_div

		///

		window!.styleMask		|=	NSClosableWindowMask
						|	NSResizableWindowMask
						|	NSMiniaturizableWindowMask
		window!.titleVisibility		=	.Hidden

		window!.setContentSize(_getMinSize())
		window!.minSize			=	window!.frame.size
		window!.setFrame(_getInitialFrameForScreen(window!.screen!, size: window!.minSize), display: false)
		window!.collectionBehavior	=	NSWindowCollectionBehavior.FullScreenPrimary

		///

		_installWindowAgent()
		_installToolbar()

		window!.delegate		=	_agent
		window!.makeKeyAndOrderFront(nil)
	}
	public func halt() {
		assert(model != nil)

		window!.delegate		=	nil
		_deinstallToolbar()
		_deinstallWindowAgent()

	}

	///

	private let	_agent		=	_Agent()
	private let	_div		=	DivisionUIController()
	private let	_tools		=	ToolUIController()

	private func _installWindowAgent() {
		_agent.owner		=	self
	}
	private func _deinstallWindowAgent() {
		_agent.owner		=	nil
	}
	private func _installToolbar() {
		assert(window!.toolbar === nil)
		_tools.run()
		window!.toolbar		=	_tools.toolbar
	}
	private func _deinstallToolbar() {
		assert(window!.toolbar === _tools.toolbar)

		window!.toolbar		=	nil
		_tools.halt()
	}

	private func _becomeCurrentWorkspace() {
		assert(model!.model.currentWorkspace.value !== self)
		if model!.model.currentWorkspace.value !== model! {
			model!.model.selectCurrentWorkspace(model!)
		}
	}
	private func _resignCurrentWorkspace() {
		assert(model!.model.currentWorkspace.value === self)
		if model!.model.currentWorkspace.value === model! {
			model!.model.deselectCurrentWorkspace()
		}
	}
}









private final class _Agent: NSObject, NSWindowDelegate {
	weak var owner: WorkspaceWindowUIController?
	@objc
	private func window(window: NSWindow, willUseFullScreenPresentationOptions proposedOptions: NSApplicationPresentationOptions) -> NSApplicationPresentationOptions {
		//	http://stackoverflow.com/questions/9263573/nstoolbar-shown-when-entering-fullscreenmode
		return	NSApplicationPresentationOptions([
			.FullScreen,
			.AutoHideToolbar,
			.AutoHideMenuBar,
			.AutoHideDock,
			])
	}

	@objc
	private func windowDidBecomeKey(notification: NSNotification) {
		owner!._becomeCurrentWorkspace()
	}
}







private func _getInitialFrameForScreen(screen: NSScreen, size: CGSize) -> CGRect {
	let	f	=	CGRect(origin: screen.frame.midPoint, size: CGSize.zeroSize)
	let	insets	=	NSEdgeInsets(top: -size.height/2, left: -size.width/2, bottom: -size.height/2, right: -size.width/2)
	let	f2	=	insets.insetRect(f)
	return	f2
}
private func _getMinSize() -> CGSize {
	return	CGSize(width: 600, height: 300)
}











