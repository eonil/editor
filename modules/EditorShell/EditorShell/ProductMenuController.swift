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

		BuildModel.Event.Notification.register				(self, ProductMenuController._process)
		DebuggingTargetExecutionModel.Event.Notification.register	(self, ProductMenuController._process)

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

		DebuggingTargetExecutionModel.Event.Notification.deregister	(self)
		BuildModel.Event.Notification.deregister			(self)
		_applyEnabledStates()
	}

	///

	private func _install() {
	}
	private func _deinstall() {
	}






	///

	private func _process(notification: BuildModel.Event.Notification) {
		guard notification.sender.workspace === model!.currentWorkspace else {
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
		guard notification.sender.target === model!.currentWorkspace?.debug.currentTarget else {
			return
		}

		_applyEnabledStates()
	}
	private func _applyEnabledStates() {
		assert(applicationUI != nil)
		assert(model != nil)

		let	ws	=	model!.currentWorkspace
		let	cmds	=	ws?.build.runnableCommands2 ?? []
		let	running	=	ws?.debug.currentTarget?.execution.value != nil
		launch.enabled	=	true
		build.enabled	=	cmds.contains(.Build)
		clean.enabled	=	cmds.contains(.Clean)
		stop.enabled	=	cmds.contains(.Stop) || running
	}

	///

	private func _runLaunchOnCurrentWorkspace() {
		assert(model!.currentWorkspace != nil)

		guard let workspace = model!.currentWorkspace else {
			fatalError()
		}
		guard let target = workspace.debug.currentTarget else {
			fatalError()
		}

		if workspace.debug.targets.count == 0 {
			markUnimplemented("We need to query `Cargo.toml` file to get proper executable location.")
			if let u = workspace.location {
				let	n	=	u.lastPathComponent!
				let	u1	=	u.URLByAppendingPathComponent("target").URLByAppendingPathComponent("debug").URLByAppendingPathComponent(n)
				workspace.debug.createTargetForExecutableAtURL(u1)
			}
		}

		workspace.debug.selectTarget(workspace.debug.targets.first!)
		workspace.debug.currentTarget!.launch(NSURL(fileURLWithPath: "."))
	}
	private func _runBuildOnCurrentWorkspace() {
		assert(model!.currentWorkspace != nil)
		if let ws = model!.currentWorkspace {
			ws.build.runBuild()
		}
	}
	private func _runCleanOnCurrentWorkspace() {
		assert(model!.currentWorkspace != nil)
		if let ws = model!.currentWorkspace {
			ws.build.runClean()
		}
	}
	private func _stopAnyOnCurrentWorkspace() {
		assert(model!.currentWorkspace != nil)
		if let ws = model!.currentWorkspace {
			ws.build.stop()
			ws.debug.currentTarget?.halt()
		}
	}
}





private final class _Agent: ValueStorageDelegate {
	weak var owner: ProductMenuController?
	private func didSet() {

	}
	private func willSet() {

	}
}













