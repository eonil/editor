//
//  ProductMenuController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorUICommon
import EditorModel

class ProductMenuController: SessionProtocol {

	weak var model: ApplicationModel?

	///

	init() {
		menu	=	_topLevelMenu("Product", items: [
			build,
			clean,
			stop,
			])
	}

	///

	let	menu		:	TopLevelCommandMenu
	let	build		=	_menuItem("Build")
	let	clean		=	_menuItem("Clean")
	let	stop		=	_menuItem("Stop")

	func run() {
		assert(model != nil)
		_applyEnabledStates()
		model!.currentWorkspace.registerWillSet(ObjectIdentifier(self)) { [weak self] in
			assert(self != nil)
			self!._handleCurrentWorkspaceWillSet()
		}
		model!.currentWorkspace.registerDidSet(ObjectIdentifier(self)) { [weak self] in
			assert(self != nil)
			self!._handleCurrentWorkspaceDidSet()
		}
	}
	func halt() {
		assert(model != nil)
		model!.currentWorkspace.deregisterDidSet(ObjectIdentifier(self))
		model!.currentWorkspace.deregisterWillSet(ObjectIdentifier(self))
	}

	///

	private func _handleCurrentWorkspaceWillSet() {
		if let ws = model!.currentWorkspace.value {
			ws.build.runnableCommands.deregisterDidSet(ObjectIdentifier(self))
			_applyEnabledStates()
		}
	}
	private func _handleCurrentWorkspaceDidSet() {
		assert(model != nil)
		if let ws = model!.currentWorkspace.value {
			_applyEnabledStates()
			ws.build.runnableCommands.registerDidSet(ObjectIdentifier(self)) { [weak self] in
				assert(self != nil)
				self!._handleCurrentWorkspaceBuildCommandsDidSet()
			}
		}
		else {

		}
	}
	private func _handleCurrentWorkspaceBuildCommandsDidSet() {
		_applyEnabledStates()
	}
	private func _applyEnabledStates() {
		assert(model != nil)
		let	cmds	=	model!.currentWorkspace.value?.build.runnableCommands.value ?? []
		build.enabled	=	cmds.contains(.Build)
		clean.enabled	=	cmds.contains(.Clean)
		stop.enabled	=	cmds.contains(.Stop)
	}
}




