//
//  ContextTreeUIController.swift
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

class ContextTreeUIController: CommonViewController {

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

	private let	_treeView	=	ContextTreeView()

	private func _install() {
		assert(model != nil)

		_treeView.reconfigure(model!.debugger)
		_treeView.onUserDidSetFrame		=	{ [weak self] in
			self?._didSetFrame()
		}
		_treeView.onUserWillSetFrame	=	{ [weak self] in
			self?._willSetFrame()
		}
		view.addSubview(_treeView)

		model!.event.register(ObjectIdentifier(self)) { [weak self] in self?._handleEvent($0) }
	}
	private func _deinstall() {
		assert(model != nil)

		model!.event.deregister(ObjectIdentifier(self))

		_treeView.removeFromSuperview()
		_treeView.onUserWillSetFrame	=	nil
		_treeView.onUserDidSetFrame		=	nil
		_treeView.reconfigure(nil)
	}
	private func _layout() {
		_treeView.frame	=	view.bounds
	}

	///

	private func _didSetFrame() {
		model!.selection.setFrame(_treeView.currentFrame)
	}
	private func _willSetFrame() {
	}

	///

	private func _handleEvent(e: LLDBEvent) {
		_treeView.reconfigure(model!.debugger)
	}
}

