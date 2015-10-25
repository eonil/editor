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

	weak var applicationUI: ApplicationUIProtocol?
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
	let	pause		=	_menuItem("Pause", shortcut: Command+Control+"Y")
	let	resume		=	_menuItem("Resume", shortcut: Command+Control+"Y")
	let	stop		=	_menuItem("Halt")
	let	stepInto	=	_menuItem("Step Into", shortcutWithLegacyUTF16CodeUnit: NSF6FunctionKey)
	let	stepOut		=	_menuItem("Step Out", shortcutWithLegacyUTF16CodeUnit: NSF7FunctionKey)
	let	stepOver	=	_menuItem("Step Over", shortcutWithLegacyUTF16CodeUnit: NSF8FunctionKey)

	func run() {
		assert(model != nil)

		func getExecution() -> DebuggingTargetExecutionModel? {
			return	_resolveCurrentWorkspaceModel()?.debug.currentTarget.value?.execution.value
		}

		pause.clickHandler	=	{ [weak self] in
			assert(self?._resolveCurrentWorkspaceModel()?.debug.currentTarget.value !== nil)
			getExecution()?.pause()
		}
		resume.clickHandler	=	{ [weak self] in
			assert(self?._resolveCurrentWorkspaceModel()?.debug.currentTarget.value !== nil)
			getExecution()?.resume()
		}
		stop.clickHandler	=	{ [weak self] in
			assert(self?._resolveCurrentWorkspaceModel()?.debug.currentTarget.value !== nil)
			getExecution()?.halt()
		}
		stepInto.clickHandler	=	{ [weak self] in
			assert(self?._resolveCurrentWorkspaceModel()?.debug.currentTarget.value !== nil)
			getExecution()?.stepInto()
		}
		stepOut.clickHandler	=	{ [weak self] in
			assert(self?._resolveCurrentWorkspaceModel()?.debug.currentTarget.value !== nil)
			getExecution()?.stepOut()
		}
		stepOver.clickHandler	=	{ [weak self] in
			assert(self?._resolveCurrentWorkspaceModel()?.debug.currentTarget.value !== nil)
			getExecution()?.stepOver()
		}

		applicationUI!.currentWorkspaceUI2.onDidBeginValue.register(self, DebugMenuController._didBeginCurrentWorkspace)
		applicationUI!.currentWorkspaceUI2.onWillEndValue.register(self, DebugMenuController._willEndCurrentWorkspace)

//		model!.currentWorkspace.registerDidSet(ObjectIdentifier(self)) { [weak self] in
//			if let ws = self?.model!.currentWorkspace.value {
//				self?._didInsertCurrentWorkspace(ws)
//			}
//		}
//		model!.currentWorkspace.registerWillSet(ObjectIdentifier(self)) { [weak self] in
//			if let ws = self?.model!.currentWorkspace.value {
//				self?._willDeleteCurrentWorkspace(ws)
//			}
//		}
	}
	func halt() {
		assert(model != nil)

//		model!.currentWorkspace.deregisterWillSet(ObjectIdentifier(self))
//		model!.currentWorkspace.deregisterDidSet(ObjectIdentifier(self))

		applicationUI!.currentWorkspaceUI2.onWillEndValue.deregister(self)
		applicationUI!.currentWorkspaceUI2.onDidBeginValue.deregister(self)
	}

	///

	private func _didBeginCurrentWorkspace(workspaceUI: WorkspaceUIProtocol?) {
		if let workspaceUI = workspaceUI {
			workspaceUI.model!.debug.currentTarget.onDidBeginValue.register(self, DebugMenuController._didBeginCurrentTarget)
			workspaceUI.model!.debug.currentTarget.onWillEndValue.register(self, DebugMenuController._willEndCurrentTarget)
		}
	}
	private func _willEndCurrentWorkspace(workspaceUI: WorkspaceUIProtocol?) {
		if let workspaceUI = workspaceUI {
			workspaceUI.model!.debug.currentTarget.onWillEndValue.deregister(self)
			workspaceUI.model!.debug.currentTarget.onDidBeginValue.deregister(self)
		}
	}

	private func _didBeginCurrentTarget(target: DebuggingTargetModel?) {
		if let target = target {
			target.execution.registerDidSet(ObjectIdentifier(self)) { [weak self, weak target] in
				precondition(target != nil)
				assert(self != nil)
				if let e = target?.execution.value {
					self?._didInsertExecution(e)
				}
			}
			target.execution.registerWillSet(ObjectIdentifier(self)) { [weak self, weak target] in
				precondition(target != nil)
				assert(self != nil)
				if let e = target?.execution.value {
					self?._willDeleteExecution(e)
				}
			}
		}
	}
	private func _willEndCurrentTarget(target: DebuggingTargetModel?) {
		if let target = target {
			target.execution.deregisterWillSet(ObjectIdentifier(self))
			target.execution.deregisterDidSet(ObjectIdentifier(self))
		}
	}
//	private func _didInsertCurrentWorkspace(workspace: WorkspaceModel) {
////		workspace.debug.currentTarget.registerDidSet(ObjectIdentifier(self)) { [weak self, weak workspace] in
////			precondition(workspace != nil)
////			assert(self != nil)
////			if let t = workspace?.debug.currentTarget.value {
////				self?._didInsertCurrentDebuggingTarget(t)
////			}
////		}
////		workspace.debug.currentTarget.registerWillSet(ObjectIdentifier(self)) { [weak self, weak workspace] in
////			precondition(workspace != nil)
////			assert(self != nil)
////			if let t = workspace?.debug.currentTarget.value {
////				self?._willDeleteCurrentDebuggingTarget(t)
////			}
////		}
//	}
//	private func _willDeleteCurrentWorkspace(workspace: WorkspaceModel) {
////		workspace.debug.currentTarget.deregisterWillSet(ObjectIdentifier(self))
////		workspace.debug.currentTarget.deregisterDidSet(ObjectIdentifier(self))
//	}

//	private func _didInsertCurrentDebuggingTarget(target: DebuggingTargetModel) {
//		target.execution.registerDidSet(ObjectIdentifier(self)) { [weak self, weak target] in
//			precondition(target != nil)
//			assert(self != nil)
//			if let e = target?.execution.value {
//				self?._didInsertExecution(e)
//			}
//		}
//		target.execution.registerWillSet(ObjectIdentifier(self)) { [weak self, weak target] in
//			precondition(target != nil)
//			assert(self != nil)
//			if let e = target?.execution.value {
//				self?._willDeleteExecution(e)
//			}
//		}
//	}
//
//	private func _willDeleteCurrentDebuggingTarget(target: DebuggingTargetModel) {
//		target.execution.deregisterWillSet(ObjectIdentifier(self))
//		target.execution.deregisterDidSet(ObjectIdentifier(self))
//	}

	private func _didInsertExecution(execution: DebuggingTargetExecutionModel) {
		_reapplyCurrentDebuggingTargetRunnableCommands()
		execution.runnableCommands.registerDidSet(ObjectIdentifier(self)) { [weak self] in self?._reapplyCurrentDebuggingTargetRunnableCommands() }
	}
	private func _willDeleteExecution(execution: DebuggingTargetExecutionModel) {
		execution.runnableCommands.deregisterDidSet(ObjectIdentifier(self))
		_reapplyCurrentDebuggingTargetRunnableCommands()
	}

	private func _reapplyCurrentDebuggingTargetRunnableCommands() {
		let	commands	=	_resolveCurrentWorkspaceModel()!.debug.currentTarget.value!.execution.value!.runnableCommands.value
		pause.enabled		=	commands.contains(DebuggingCommand.Pause)
		resume.enabled		=	commands.contains(DebuggingCommand.Resume)
		stop.enabled		=	commands.contains(DebuggingCommand.Halt)
		stepInto.enabled	=	commands.contains(DebuggingCommand.StepInto)
		stepOut.enabled		=	commands.contains(DebuggingCommand.StepOut)
		stepOver.enabled	=	commands.contains(DebuggingCommand.StepOver)
	}

	///

	private func _resolveCurrentWorkspaceModel() -> WorkspaceModel? {
		return	applicationUI!.currentWorkspaceUI2.value?.model
	}
}




