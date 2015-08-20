//
//  DebugMenuController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/20.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel

class DebugMenuController: SessionProtocol {

	weak var model: ApplicationModel?

	///

	init() {
		menu	=
			_topLevelMenu("Debug", items: [
				pause,
				resume,
				stop,
				_menuSeparatorItem(),
				stepInto,
				stepOut,
				stepOver,
				])

	}

	///

	let	menu		:	TopLevelCommandMenu
	let	pause		=	_menuItem("Pause")
	let	resume		=	_menuItem("Resume")
	let	stop		=	_menuItem("Halt")
	let	stepInto	=	_menuItem("Step Into")
	let	stepOut		=	_menuItem("Step Out")
	let	stepOver	=	_menuItem("Step Over")

	func run() {
		assert(model != nil)

		

		model!.currentWorkspace.registerDidSet(ObjectIdentifier(self)) { [weak self] in
			if let ws = self?.model!.currentWorkspace.value {
				self?._didInsertCurrentWorkspace(ws)
			}
		}
		model!.currentWorkspace.registerWillSet(ObjectIdentifier(self)) { [weak self] in
			if let ws = self?.model!.currentWorkspace.value {
				self?._willDeleteCurrentWorkspace(ws)
			}
		}
	}
	func halt() {
		assert(model != nil)

		model!.currentWorkspace.deregisterWillSet(ObjectIdentifier(self))
		model!.currentWorkspace.deregisterDidSet(ObjectIdentifier(self))
	}

	///

	private func _didInsertCurrentWorkspace(workspace: WorkspaceModel) {
		workspace.debug.currentTarget.registerDidSet(ObjectIdentifier(self)) { [weak self] in
			if let t = workspace.debug.currentTarget.value {
				self?._didInsertCurrentDebuggingTarget(t)
			}
		}
		workspace.debug.currentTarget.registerWillSet(ObjectIdentifier(self)) { [weak self] in
			if let t = workspace.debug.currentTarget.value {
				self?._willDeleteCurrentDebuggingTarget(t)
			}
		}
	}
	private func _willDeleteCurrentWorkspace(workspace: WorkspaceModel) {
		workspace.debug.currentTarget.deregisterWillSet(ObjectIdentifier(self))
		workspace.debug.currentTarget.deregisterDidSet(ObjectIdentifier(self))
	}

	private func _didInsertCurrentDebuggingTarget(target: DebuggingTargetModel) {
		target.runnableCommands.registerDidSet(ObjectIdentifier(self)) { [weak self] in self?._reapplyCurrentDebuggingTargetRunnableCommands() }
	}

	private func _willDeleteCurrentDebuggingTarget(target: DebuggingTargetModel) {
		target.runnableCommands.deregisterDidSet(ObjectIdentifier(self))
	}

	private func _reapplyCurrentDebuggingTargetRunnableCommands() {
		let	t		=	model!.currentWorkspace.value!.debug.currentTarget.value!
		pause.enabled		=	t.runnableCommands.value.contains(DebuggingCommand.Pause)
		resume.enabled		=	t.runnableCommands.value.contains(DebuggingCommand.Resume)
		stop.enabled		=	t.runnableCommands.value.contains(DebuggingCommand.Halt)
		stepInto.enabled	=	t.runnableCommands.value.contains(DebuggingCommand.StepInto)
		stepOut.enabled		=	t.runnableCommands.value.contains(DebuggingCommand.StepOut)
		stepOver.enabled	=	t.runnableCommands.value.contains(DebuggingCommand.StepOver)
	}
}




