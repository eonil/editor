//
//  DebugFrameVariableTreeUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper
import EditorModel
import EditorUICommon
import EditorDebugUI

class DebugFrameVariableTreeUIController: CommonViewController {

	weak var model: DebuggingModel?

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

	///

	private let	_treeView	=	VariableTreeView()

	private func _install() {
		assert(model != nil)
		view.addSubview(_treeView)
		DebuggingModel.Event.Notification.register			(self, DebugFrameVariableTreeUIController._process)
		DebuggingTargetExecutionModel.Event.Notification.register	(self, DebugFrameVariableTreeUIController._processDebuggingTargetExecutionModelEventNotification)
		UIState.ForWorkspaceModel.Notification.register			(self, DebugFrameVariableTreeUIController._process)
	}
	private func _deinstall() {
		assert(model != nil)
		UIState.ForWorkspaceModel.Notification.deregister		(self)	
		DebuggingTargetExecutionModel.Event.Notification.deregister	(self)
		DebuggingModel.Event.Notification.deregister			(self)
		_treeView.removeFromSuperview()
	}
	private func _layout() {
		_treeView.frame		=	view.bounds
	}

	///

	private func _process(n: DebuggingModel.Event.Notification) {
		guard n.sender === model else {
			return
		}

		switch n.event {
		case .WillMutate:	break
		case .DidMutate:	_applyFrameSelection()
		}
	}
	private func _processDebuggingTargetExecutionModelEventNotification(notification: DebuggingTargetExecutionModel.Event.Notification) {

	}
	private func _process(n: UIState.ForWorkspaceModel.Notification) {
		guard n.sender === model!.workspace else {
			return
		}
		UIState.ForWorkspaceModel.get(model!.workspace) {
			_treeView.reconfigure($0.debuggingSelection.frame)
		}
	}




	private func _applyFrameSelection() {
		if let frame = model!.selection.frame.value {
			_treeView.reconfigure(frame)
		}
		else {
			_treeView.reconfigure(nil)
		}
	}
}

















