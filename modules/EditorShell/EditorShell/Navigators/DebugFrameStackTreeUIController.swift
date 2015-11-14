//
//  DebugFrameStackTreeUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper
import MulticastingStorage
import EditorCommon
import EditorModel
import EditorUICommon
import EditorDebugUI

class DebugFrameStackTreeUIController: CommonViewController {

	weak var model: DebuggingModel? 










	///

	override func installSubcomponents() {
		super.installSubcomponents()
		_install()
	}
	override func deinstallSubcomponents() {
		_deinstall()
		super.deinstallSubcomponents()
	}
	override func layoutSubcomponents() {
		super.layoutSubcomponents()
		_layout()
	}

	override var acceptsFirstResponder: Bool {
		get {
			return	_treeUI.acceptsFirstResponder
		}
	}
	override func becomeFirstResponder() -> Bool {
		return	view.window!.makeFirstResponder(_treeUI)
	}


















	///

	private let _treeUI	=	ContextTreeUI()

	private func _install() {
		_treeUI.model	=	model!
		view.addSubview(_treeUI)
	}
	private func _deinstall() {
		_treeUI.removeFromSuperview()
		_treeUI.model	=	nil
	}
	private func _layout() {
		_treeUI.frame	=	view.bounds
	}

//	private let	_treeView	=	ContextTreeView()
//
//	private func _install() {
//		assert(model != nil)
//
//		_treeView.reconfigure(model!.debugger)
//		_treeView.onUserDidSetFrame		=	{ [weak self] in
//			self?._didSetFrame()
//		}
//		_treeView.onUserWillSetFrame	=	{ [weak self] in
//			self?._willSetFrame()
//		}
//		view.addSubview(_treeView)
//
//		DebuggingModel.Event.Notification.register	(self, FrameStackTreeUIController._processDebuggingNotification)
//	}
//	private func _deinstall() {
//		assert(model != nil)
//
//		DebuggingModel.Event.Notification.deregister	(self)
//		
//		_treeView.removeFromSuperview()
//		_treeView.onUserWillSetFrame	=	nil
//		_treeView.onUserDidSetFrame		=	nil
//		_treeView.reconfigure(nil)
//	}
//	private func _layout() {
//		_treeView.frame	=	view.bounds
//	}
//
//	///
//
//	private func _didSetFrame() {
//		model!.selection.setFrame(_treeView.currentFrame)
//	}
//	private func _willSetFrame() {
//	}
//
//	///
//
//	private func _processDebuggingNotification(notification: DebuggingModel.Event.Notification) {
//		guard notification.sender === model else {
//			return
//		}
//
//		_treeView.reconfigure(model!.debugger)
//	}
}

