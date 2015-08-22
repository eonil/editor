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
		assert(model != nil)
		_applyEnabledStates()
		model!.currentWorkspace.registerWillSet(ObjectIdentifier(self)) { [weak self] in
			assert(self != nil)
			self!._willSetCurrentWorkspace()
		}
		model!.currentWorkspace.registerDidSet(ObjectIdentifier(self)) { [weak self] in
			assert(self != nil)
			self!._didSetCurrentWorkspace()
		}

		launch.clickHandler	=	{ [weak self] in self?._runLaunchOnCurrentWorkspace() }
		build.clickHandler	=	{ [weak self] in self?._runBuildOnCurrentWorkspace() }
		clean.clickHandler	=	{ [weak self] in self?._runCleanOnCurrentWorkspace() }
		stop.clickHandler	=	{ [weak self] in self?._stopAnyBuildOperationOnCurrentWorkspace() }

	}
	func halt() {
		assert(model != nil)

		stop.clickHandler	=	nil
		clean.clickHandler	=	nil
		build.clickHandler	=	nil

		model!.currentWorkspace.deregisterDidSet(ObjectIdentifier(self))
		model!.currentWorkspace.deregisterWillSet(ObjectIdentifier(self))
	}

	///

//	private let	_workspaceToBuildCommandRouting	=	SelectionChain<WorkspaceModel,Set<BuildCommand>> { $0.build.runnableCommands }
//	private let	_workspaceToTargetRouting	=	SelectionChain<WorkspaceModel,DebuggingTargetModel?> { $0.debug.currentTarget }

	private func _install() {
//		_workspaceToTargetRouting.storage			=	model!.currentWorkspace
//		_workspaceToTargetRouting.didSetSubstorageValue		=	{ [weak self] in self!._didSetCurrentTarget($0) }
//		_workspaceToTargetRouting.willSetSubstorageValue	=	{ [weak self] in self!._willSetCurrentTarget($0) }
	}
	private func _deinstall() {
//		_workspaceToTargetRouting.didSetSubstorageValue		=	nil
//		_workspaceToTargetRouting.willSetSubstorageValue	=	nil
//		_workspaceToTargetRouting.storage			=	nil

	}
	private func _didSetCurrentWorkspace() {
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
	private func _willSetCurrentWorkspace() {
		if let ws = model!.currentWorkspace.value {
			ws.build.runnableCommands.deregisterDidSet(ObjectIdentifier(self))
			_applyEnabledStates()
		}
	}

	private func _didSetCurrentTarget(t: DebuggingTargetModel?) {
		_applyEnabledStates()
	}
	private func _willSetCurrentTarget(t: DebuggingTargetModel?) {

	}

	private func _handleCurrentWorkspaceBuildCommandsDidSet() {
		_applyEnabledStates()
	}
	private func _applyEnabledStates() {
		assert(model != nil)
		let	cmds	=	model!.currentWorkspace.value?.build.runnableCommands.value ?? []
		let	running	=	model!.currentWorkspace.value?.debug.currentTarget.value?.execution.value != nil
		launch.enabled	=	true
		build.enabled	=	cmds.contains(.Build)
		clean.enabled	=	cmds.contains(.Clean)
		stop.enabled	=	cmds.contains(.Stop) || running
	}

	///

	private func _runLaunchOnCurrentWorkspace() {
		assert(model!.currentWorkspace.value != nil)
		if let ws = model!.currentWorkspace.value {
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
		assert(model!.currentWorkspace.value != nil)
		if let ws = model!.currentWorkspace.value {
			ws.build.runBuild()
		}
	}
	private func _runCleanOnCurrentWorkspace() {
		assert(model!.currentWorkspace.value != nil)
		if let ws = model!.currentWorkspace.value {
			ws.build.runClean()
		}
	}
	private func _stopAnyBuildOperationOnCurrentWorkspace() {
		assert(model!.currentWorkspace.value != nil)
		if let ws = model!.currentWorkspace.value {
			ws.build.stop()
		}
	}
}









