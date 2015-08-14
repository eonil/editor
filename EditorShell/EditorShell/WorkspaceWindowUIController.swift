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

public final class WorkspaceWindowUIController: CommonUIWindowController, NSWindowDelegate {
	
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

		window!.delegate		=	_agent
		window!.makeKeyAndOrderFront(nil)

		_installToolbar()
	}
	public func halt() {
		assert(model != nil)
		
		_deinstallToolbar()

		window!.delegate		=	nil
	}

	///

	private let	_agent		=	_Agent()
	private let	_div		=	DivisionUIController()
	private let	_tools		=	ToolUIController()

	private func _installToolbar() {
		assert(window!.toolbar === nil)
		_tools.run()
		window!.toolbar		=	_tools.toolbar
		registerShellConsumer(_tools)
	}
	private func _deinstallToolbar() {
		assert(window!.toolbar === _tools.toolbar)

		deregisterShellConsumer(_tools)
		window!.toolbar		=	nil
		_tools.halt()
	}
}









private final class _Agent: NSObject, NSWindowDelegate {
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











