//
//  VariableTreeUIController.swift
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

class VariableTreeUIController: CommonUIController {

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

		_didSetFrame()
		model!.selection.frame.registerDidSet(ObjectIdentifier(self)) { [weak self] in self!._didSetFrame() }
		model!.selection.frame.registerWillSet(ObjectIdentifier(self)) { [weak self] in self!._willSetFrame() }
		model!.event.register(ObjectIdentifier(self)) { [weak self] in self?._handleEvent($0) }
	}
	private func _deinstall() {
		assert(model != nil)

		model!.event.deregister(ObjectIdentifier(self))
		model!.selection.frame.deregisterDidSet(ObjectIdentifier(self))
		model!.selection.frame.deregisterWillSet(ObjectIdentifier(self))
		_willSetFrame()

		_treeView.removeFromSuperview()
	}
	private func _layout() {
		_treeView.frame		=	view.bounds
	}

	///

	private func _didSetFrame() {
		if let frame = model!.selection.frame.value {
			_treeView.reconfigure(frame)
		}
	}
	private func _willSetFrame() {
		if let _ = model!.selection.frame.value {
			_treeView.reconfigure(nil)
		}
	}

	private func _handleEvent(event: LLDBEvent) {
		if let frame = model!.selection.frame.value {
			_treeView.reconfigure(frame)
		}
		else {
			_treeView.reconfigure(nil)
		}

	}
}




