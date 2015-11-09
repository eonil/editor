//
//  MainMenuAvailabilityManager.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/07.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorModel

class MainMenuAvailabilityManager {

	init() {
	}
	deinit {
		assert(isRunning == false)
	}


	weak var mainMenuController: MainMenuController?
	weak var model: ApplicationModel?

	var isRunning: Bool = false {
		willSet {
			if isRunning == true {
				_deinstall()
			}
		}
		didSet {
			if isRunning == true {
				_install()
			}
		}
	}









	///

	private func _install() {
		assert(model != nil)
		_applyFileStateChange()
		_applyBuildStateChange()
		_applyDebuggingStateChange()
		_applyUIStateChange()
		ApplicationModel.Event.Notification.register			(self, MainMenuAvailabilityManager._process)
		DebuggingModel.Event.Notification.register			(self, MainMenuAvailabilityManager._process)
		DebuggingTargetModel.Event.Notification.register		(self, MainMenuAvailabilityManager._process)
		DebuggingTargetExecutionModel.Event.Notification.register	(self, MainMenuAvailabilityManager._process)
	}
	private func _deinstall() {
		assert(model != nil)
		DebuggingTargetExecutionModel.Event.Notification.deregister	(self)
		DebuggingTargetModel.Event.Notification.deregister		(self)
		DebuggingModel.Event.Notification.deregister			(self)
		ApplicationModel.Event.Notification.deregister			(self)
		_applyUIStateChange()
		_applyDebuggingStateChange()
		_applyBuildStateChange()
		_applyFileStateChange()
	}

	private func _process(n: ApplicationModel.Event.Notification) {
		_applyFileStateChange()
		_applyBuildStateChange()
	}
	private func _process(n: DebuggingModel.Event.Notification) {
		guard n.sender === model!.currentWorkspace?.debug else {
			return
		}
		_applyDebuggingStateChange()
	}
	private func _process(n: DebuggingTargetModel.Event.Notification) {
		guard n.sender === model!.currentWorkspace?.debug.currentTarget else {
			return
		}
		_applyDebuggingStateChange()
	}
	private func _process(n: DebuggingTargetExecutionModel.Event.Notification) {
		guard n.sender === model!.currentWorkspace?.debug.currentTarget?.execution else {
			return
		}
		_applyDebuggingStateChange()
	}
	private func _process(n: Notification<WorkspaceModel, UIState.Event>) {
		guard n.sender === model!.currentWorkspace else {
			return
		}
		_applyUIStateChange()
	}






	private func _applyFileStateChange() {
		mainMenuController!.fileCloseCurrentWorkspace.enabled	=	model!.currentWorkspace != nil
	}
	private func _applyBuildStateChange() {
		mainMenuController!.productRun.enabled		=	model!.currentWorkspace != nil
		mainMenuController!.productBuild.enabled	=	model!.currentWorkspace?.build.runnableCommands.contains(.Build) ?? false
		mainMenuController!.productClean.enabled	=	model!.currentWorkspace?.build.runnableCommands.contains(.Clean) ?? false
		mainMenuController!.productStop.enabled		=	(model!.currentWorkspace?.build.runnableCommands.contains(.Stop) ?? false)
								||	(model!.currentWorkspace?.debug.currentTarget?.execution?.runnableCommands.contains(.Halt) ?? false)
	}
	private func _applyDebuggingStateChange() {
		let	cmds	=	model!.currentWorkspace?.debug.currentTarget?.execution?.runnableCommands ?? []
		mainMenuController!.debugPause.enabled		=	cmds.contains(.Pause)
		mainMenuController!.debugResume.enabled		=	cmds.contains(.Resume)
		mainMenuController!.debugHalt.enabled		=	cmds.contains(.Halt)
		mainMenuController!.debugStepInto.enabled	=	cmds.contains(.StepInto)
		mainMenuController!.debugStepOut.enabled	=	cmds.contains(.StepOut)
		mainMenuController!.debugStepOver.enabled	=	cmds.contains(.StepOver)
	}
	private func _applyUIStateChange() {
		mainMenuController!.viewShowProjectNavivator.enabled	=	true
		mainMenuController!.viewShowDebugNavivator.enabled	=	true
		mainMenuController!.viewHideNavigator.enabled		=	true
	}
}































