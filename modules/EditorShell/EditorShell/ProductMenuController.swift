//
//  ProductMenuController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import MulticastingStorage
import EditorCommon
import EditorUICommon
import EditorModel

class ProductMenuController: SessionProtocol {

	weak var applicationUI	:	ApplicationUIProtocol?
	weak var model		:	ApplicationModel?

	///

	init() {
		menu	=
			_topLevelMenu("Product", items: [
				launch,
				build,
				clean,
				stop,
				])
	}

	///

	let	menu		:	TopLevelCommandMenu
	let	launch		=	_menuItem("Run", shortcut: Command+"R")
	let	build		=	_menuItem("Build", shortcut: Command+"B")
	let	clean		=	_menuItem("Clean", shortcut: Command+"K")
	let	stop		=	_menuItem("Stop", shortcut: Command+".")

	func run() {
		assert(applicationUI != nil)
		assert(model != nil)
		_applyEnabledStates()

		model!.event.register(self, ProductMenuController._processEvent)
//		ApplicationUIController.Event.register		(self, ProductMenuController._process)
		BuildModel.Event.register			(self, ProductMenuController._process)
		DebuggingTargetExecutionModel.Event.register	(self, ProductMenuController._process)
//		ApplicationUIController.Event.register(self)		{ [weak self] in self?._process($0) }
//		BuildModel.Event.register(self)				{ [weak self] in self?._process($0) }
//		DebuggingTargetExecutionModel.Event.register(self)	{ [weak self] in self?._process($0) }

//		_didSetDefaultWorkspace()
//		model!.currentWorkspace.registerWillSet(ObjectIdentifier(self)) { [weak self] in
//			assert(self != nil)
//			self!._didSetDefaultWorkspace()
//		}
//		model!.currentWorkspace.registerDidSet(ObjectIdentifier(self)) { [weak self] in
//			assert(self != nil)
//			self!._didSetDefaultWorkspace()
//		}

		launch.clickHandler	=	{ [weak self] in self?._runLaunchOnCurrentWorkspace() }
		build.clickHandler	=	{ [weak self] in self?._runBuildOnCurrentWorkspace() }
		clean.clickHandler	=	{ [weak self] in self?._runCleanOnCurrentWorkspace() }
		stop.clickHandler	=	{ [weak self] in self?._stopAnyOnCurrentWorkspace() }
	}
	func halt() {
		assert(applicationUI != nil)
		assert(model != nil)

		stop.clickHandler	=	nil
		clean.clickHandler	=	nil
		build.clickHandler	=	nil

//		model!.currentWorkspace.deregisterDidSet(ObjectIdentifier(self))
//		model!.currentWorkspace.deregisterWillSet(ObjectIdentifier(self))
//		_willSetDefaultWorkspace()

		DebuggingTargetExecutionModel.Event.deregister	(self)
		BuildModel.Event.deregister			(self)
//		ApplicationUIController.Event.deregister	(self)
		_applyEnabledStates()
	}

	///

	private func _install() {
	}
	private func _deinstall() {
	}

	///

	private func _processEvent(event: ApplicationModel.Event) {
		_applyEnabledStates()
		switch event {
		case .DidChangeCurrentWorkspace(let ws):
			if let ws = ws {
				ws.debug.currentTarget
			}

		case .WillChangeCurrentWorkspace(let ws):
			if let ws = ws {
				ws.debug.currentTarget
			}

		default:
			break
		}
	}
	private func _processEvent(event: DebuggingModel.Event) {
		_applyEnabledStates()
		switch event {
		case .WillChangeCurrentTarget(let target):
			if let target = target {
				target.event.register(self, ProductMenuController._processEvent)
			}
		case .DidChangeCurrentTarget(let target):
			if let target = target {
				target.event.deregister(self)
			}
		}
	}
	private func _processEvent(event: DebuggingTargetModel.Event) {
		_applyEnabledStates()
		switch event {
		case .WillChangeExecution(let execution):
			if let execution = execution {
				execution.event.register(self, ProductMenuController._processEvent)
			}
		case .DidChangeExecution(let execution):
			if let execution = execution {
				execution.event.deregister(self)
			}
		}
	}
	private func _processEvent(event: DebuggingTargetExecutionModel.Event) {
		_applyEnabledStates()
	}
	private func _process(notification: BuildModel.Event.Notification) {
		guard notification.sender.workspace === applicationUI!.currentWorkspaceUI2.value?.model else {
			return
		}

		switch notification.event {
		case .WillChangeRunnableCommand:
			_applyEnabledStates()

		case .DidChangeRunnableCommand:
			_applyEnabledStates()
		}
	}
	private func _process(notification: DebuggingTargetExecutionModel.Event.Notification) {
		guard notification.sender.target === applicationUI!.currentWorkspaceUI2.value?.model?.debug.currentTarget.value else {
			return
		}
		switch notification.event {
		case .WillChangeState:
			_applyEnabledStates()

		case .DidChangeState:
			_applyEnabledStates()
		}
	}

	private func _handleCurrentWorkspaceBuildCommandsDidSet() {
		_applyEnabledStates()
	}
	private func _applyEnabledStates() {
		assert(applicationUI != nil)
		assert(model != nil)

		let	ws	=	applicationUI!.currentWorkspaceUI2.value?.model
		let	cmds	=	ws?.build.runnableCommands2 ?? []
		let	running	=	ws?.debug.currentTarget.value?.execution.value != nil
		launch.enabled	=	true
		build.enabled	=	cmds.contains(.Build)
		clean.enabled	=	cmds.contains(.Clean)
		stop.enabled	=	cmds.contains(.Stop) || running
	}

	///

	private func _runLaunchOnCurrentWorkspace() {
		assert(_resolveCurrentWorkspaceModel() != nil)
		if let ws = _resolveCurrentWorkspaceModel() {
			if ws.debug.currentTarget.value == nil {
				if ws.debug.targets.array.count == 0 {
					markUnimplemented("We need to query `Cargo.toml` file to get proper executable location.")
					if let u = ws.location.value {
						let	n	=	u.lastPathComponent!
						let	u1	=	u.URLByAppendingPathComponent("target").URLByAppendingPathComponent("debug").URLByAppendingPathComponent(n)
						ws.debug.createTargetForExecutableAtURL(u1)
					}
				}
				ws.debug.selectTarget(ws.debug.targets.array.first!)
			}
			ws.debug.currentTarget.value!.launch(NSURL(fileURLWithPath: "."))
		}
	}
	private func _runBuildOnCurrentWorkspace() {
		assert(_resolveCurrentWorkspaceModel() != nil)
		if let ws = _resolveCurrentWorkspaceModel() {
			ws.build.runBuild()
		}
	}
	private func _runCleanOnCurrentWorkspace() {
		assert(_resolveCurrentWorkspaceModel() != nil)
		if let ws = _resolveCurrentWorkspaceModel() {
			ws.build.runClean()
		}
	}
	private func _stopAnyOnCurrentWorkspace() {
		assert(_resolveCurrentWorkspaceModel() != nil)
		if let ws = _resolveCurrentWorkspaceModel() {
			ws.build.stop()
			ws.debug.currentTarget.value?.halt()
		}
	}

	///

	private func _resolveCurrentWorkspaceModel() -> WorkspaceModel? {
		return	applicationUI!.currentWorkspaceUI2.value?.model
	}
}





private final class _Agent: ValueStorageDelegate {
	weak var owner: ProductMenuController?
	private func didSet() {

	}
	private func willSet() {

	}
}













