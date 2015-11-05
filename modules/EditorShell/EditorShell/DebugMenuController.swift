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
	let	pause		=	_menuItem("Pause", shortcut: Command+Control+"Y")
	let	resume		=	_menuItem("Resume", shortcut: Command+Control+"Y")
	let	stop		=	_menuItem("Halt")
	let	stepInto	=	_menuItem("Step Into", shortcutWithLegacyUTF16CodeUnit: NSF6FunctionKey)
	let	stepOut		=	_menuItem("Step Out", shortcutWithLegacyUTF16CodeUnit: NSF7FunctionKey)
	let	stepOver	=	_menuItem("Step Over", shortcutWithLegacyUTF16CodeUnit: NSF8FunctionKey)

	func run() {
		assert(model != nil)

		let	getExecution	=	{ [weak self] () -> DebuggingTargetExecutionModel? in
			assert(self != nil)
			assert(self!.model!.currentWorkspace?.debug.currentTarget != nil)
			return	self!.model!.currentWorkspace?.debug.currentTarget?.execution.value
		}

		pause.clickHandler	=	{ getExecution()?.pause() }
		resume.clickHandler	=	{ getExecution()?.resume() }
		stop.clickHandler	=	{ getExecution()?.halt() }
		stepInto.clickHandler	=	{ getExecution()?.stepInto() }
		stepOut.clickHandler	=	{ getExecution()?.stepOut() }
		stepOver.clickHandler	=	{ getExecution()?.stepOver() }


		DebuggingTargetExecutionModel.Event.Notification.register	(self, DebugMenuController._processDebuggingTargetExecutionNotification)
	}
	func halt() {
		assert(model != nil)
		DebuggingTargetExecutionModel.Event.Notification.deregister	(self)
	}








	///

	private func _processDebuggingTargetExecutionNotification(notification: DebuggingTargetExecutionModel.Event.Notification) {
		guard notification.sender.target.debugging.workspace === model!.currentWorkspace else {
			return
		}

		_reapplyCurrentDebuggingTargetRunnableCommands()
	}



	private func _reapplyCurrentDebuggingTargetRunnableCommands() {
		let	commands	=	model!.currentWorkspace!.debug.currentTarget!.execution.value!.runnableCommands.value
		pause.enabled		=	commands.contains(DebuggingCommand.Pause)
		resume.enabled		=	commands.contains(DebuggingCommand.Resume)
		stop.enabled		=	commands.contains(DebuggingCommand.Halt)
		stepInto.enabled	=	commands.contains(DebuggingCommand.StepInto)
		stepOut.enabled		=	commands.contains(DebuggingCommand.StepOut)
		stepOver.enabled	=	commands.contains(DebuggingCommand.StepOver)
	}

}




