
//  WorkspaceWindowUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel
import EditorCommon
import EditorUICommon

public final class WorkspaceWindowUIController: CommonWindowController, SessionProtocol {

	public override init() {
		super.init()
		Debug.log("WorkspaceWindowUIController `\(self)` init")
	}
	deinit {
		Debug.log("WorkspaceWindowUIController `\(self)` deinit")
	}








	///

	/// Will be set by upper level node.
	public weak var model: WorkspaceModel? {
		didSet {
			_tools.model	=	model
			_div.model	=	model
		}
	}
	











	///

	public func run() {
		assert(model != nil)

		_reconfigureWindowAppearanceBehaviors()

		_div.view.frame			=	CGRect(origin: CGPoint.zero, size: _getMinSize())
		window!.contentViewController	=	_div

		///

		_installWindowAgent()
		_installToolbar()

		window!.delegate		=	_agent
		window!.makeKeyAndOrderFront(nil)

		UIState.ForWorkspaceModel.set(model!) {
			$0.navigationPaneVisibility	=	true
			$0.inspectionPaneVisibility	=	false
			$0.consolePaneVisibility	=	true
		}
	}
	public func halt() {
		assert(model != nil)

		window!.orderOut(self)
		
		window!.delegate		=	nil
		window!.contentViewController	=	nil
		_deinstallToolbar()
		_deinstallWindowAgent()
	}

	///

	private let	_agent		=	_Agent()
	private let	_div		=	DivisionUIController2()
	private let	_tools		=	ToolUIController()

	private func _reconfigureWindowAppearanceBehaviors() {
		window!.collectionBehavior	=	NSWindowCollectionBehavior.FullScreenPrimary
		window!.styleMask		|=	NSClosableWindowMask
						|	NSResizableWindowMask
						|	NSMiniaturizableWindowMask
		window!.titleVisibility		=	.Hidden

		window!.setContentSize(_getMinSize())
		window!.minSize			=	window!.frame.size
		window!.setFrame(_getInitialFrameForScreen(window!.screen!, size: window!.minSize), display: false)
	}
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

//	private func _becomeCurrentWorkspace() {
////		if model!.application.currentWorkspace.value !== self {
//////			if model!.application.currentWorkspace.value != nil {
//////				model!.application.deselectCurrentWorkspace()
//////			}
//////			model!.application.selectCurrentWorkspace(model!)
//////			model!.application.reselectCurrentWorkspace(model!)
////		}
//
//		Event.DidBecomeCurrent.dualcastAsNotificationWithSender(self)
//	}
//	private func _resignCurrentWorkspace() {
//		Event.WillResignCurrent.dualcastAsNotificationWithSender(self)
//
////		assert(model!.application.currentWorkspace.value === self)
////		model!.application.reselectCurrentWorkspace
////		markUnimplemented()
//	}
	private func _closeCurrentWorkspace() {
		model!.application.closeWorkspace(model!)
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

//	@objc
//	private func windowDidBecomeMain(notification: NSNotification) {
////		print(notification)
////		owner!._becomeCurrentWorkspace()
//	}
//	@objc
//	private func windowDidResignMain(notification: NSNotification) {
////		print(notification)
////		owner!._resignCurrentWorkspace()
//	}

	@objc
	private func windowWillClose(notification: NSNotification) {
		owner!._closeCurrentWorkspace()
	}
}







private func _getInitialFrameForScreen(screen: NSScreen, size: CGSize) -> CGRect {
	let	f	=	CGRect(origin: screen.frame.midPoint, size: CGSize.zero)
	let	insets	=	NSEdgeInsets(top: -size.height/2, left: -size.width/2, bottom: -size.height/2, right: -size.width/2)
	let	f2	=	insets.insetRect(f)
	return	f2
}
private func _getMinSize() -> CGSize {
	return	CGSize(width: 600, height: 300)
}











