//
//  DebuggingTargetModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/21.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import LLDBWrapper
import EditorCommon

/// A wrapper around `LLDBTarget` to provide UI-friendly interface
///
public class DebuggingTargetModel: ModelSubnode<DebuggingModel> {

	internal init(LLDBTarget lldbTarget: LLDBTarget) {
		_lldbTarget	=	lldbTarget
	}

	///

	public var event: MulticastChannel<Event> {
		get {
			return	_event
		}
	}
	public var debugging: DebuggingModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	public override func didJoinModelRoot() {
		super.didJoinModelRoot()
		_install()
	}
	public override func willLeaveModelRoot() {
		_deinstall()
		super.willLeaveModelRoot()
	}

	///

	public var LLDBObject: LLDBTarget {
		get {
			return	_lldbTarget
		}
	}

	public var execution: ValueStorage<DebuggingTargetExecutionModel?> {
		get {
			return	_execution
		}
	}
	public func launch(workingDirectoryURL: NSURL) {
		_launch(workingDirectoryURL)
	}
	public func halt() {
		_halt()
	}

	///

	private let	_event			=	MulticastStation<Event>()
	private let	_runnableCommands	=	MutableValueStorage<Set<DebuggingCommand>>([])
	private let	_lldbTarget		:	LLDBTarget
	private let	_execution		=	MutableValueStorage<DebuggingTargetExecutionModel?>(nil)

	///

	private func _install() {
	}
	private func _deinstall() {
	}

	private func _launch(workingDirectoryURL: NSURL) {
		assert(owner != nil)
		assert(_execution.value == nil)

		let	b		=	_lldbTarget.createBreakpointByName("main")
		b.enabled		=	true

		let	p		=	_lldbTarget.launchProcessSimplyWithWorkingDirectory(workingDirectoryURL.path)
		assert(p != nil)
		Debug.log(p!.state.rawValue)
//		assert(p!.state == .Stopped)
		let	m		=	DebuggingTargetExecutionModel(LLDBProcess: p)
		m.owner			=	self
		_execution.value	=	m
	}
	private func _halt() {
		assert(owner != nil)
		assert(_execution.value != nil)

		_execution.value!.halt()
		_execution.value!.owner	=	nil
		_execution.value	=	nil
	}
}






























private func _runnableCommandsForProcess(process: LLDBProcess) -> Set<DebuggingCommand> {
	switch process.state {
	case .Stopped:
		fallthrough
	case .Suspended:
		return	[.Resume, .StepOver, .StepInto, .StepOut]

	case .Running:
		fallthrough
	case .Stepping:
		return	[.Halt, .Pause]

	case .Attaching:
		fallthrough
	case .Connected:
		fallthrough
	case .Crashed:
		fallthrough
	case .Detached:
		fallthrough
	case .Exited:
		fallthrough
	case .Invalid:
		fallthrough
	case .Launching:
		fallthrough

	case .Unloaded:
		return	[]
	}
}
private func _runnableCommandsForThread(thread: LLDBThread) -> Set<DebuggingCommand> {
	if thread.stopped {
		return	[
			DebuggingCommand.Halt,
			DebuggingCommand.Resume,
			DebuggingCommand.StepInto,
			DebuggingCommand.StepOut,
			DebuggingCommand.StepOver,
		]
	}
	else {
		return	[
			DebuggingCommand.Halt,
			DebuggingCommand.Pause,
		]
	}
}










