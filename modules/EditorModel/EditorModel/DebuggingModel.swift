//
//  DebuggingModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import LLDBWrapper
import EditorCommon

public enum DebuggingCommand {
	case Halt
	case Pause
	case Resume
	case StepOver
	case StepInto
	case StepOut
}

public class DebuggingModel: ModelSubnode<WorkspaceModel> {

	public var workspace: WorkspaceModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	///



	///


//	public var stackFrames: ArrayStorage<StackFrame> {
//		get {
//			return	_stackFrames
//		}
//	}
//	public var frameVariables: ArrayStorage<FrameVariable> {
//		get {
//			return	_frameVariables
//		}
//	}

	public var targets: ArrayStorage<DebuggingTargetModel> {
		get {
			return	_targets
		}
	}
	public var currentTarget: ValueStorage<DebuggingTargetModel?> {
		get {
			return	_currentTarget
		}
	}

//	public func launch() {
//
//	}

	/// Currently, supports only 64-bit arch.
	public func createTargetForExecutableAtURL(u: NSURL) -> DebuggingTargetModel {
		precondition(u.scheme == "file")
		let	t	=	_lldbDebugger.createTargetWithFilename(u.path!, andArchname: LLDBArchDefault64Bit)
		assert(_lldbDebugger.allTargets.contains(t), "Could not create a target for URL `\(u)`.")
		let	m	=	DebuggingTargetModel(LLDBTarget: t)
		_targets.insert([m], atIndex: _targets.array.startIndex)
		return	m
	}
	public func deleteTarget(target: DebuggingTargetModel) {
		if let idx = _targets.array.indexOfValueByReferentialIdentity(target) {
			_lldbDebugger.deleteTarget(target._lldbTarget)
			_targets.delete(idx...idx)
		}
	}

	public func selectTarget(target: DebuggingTargetModel) {
		_currentTarget.value	=	target
	}
	public func deselectTarget(target: DebuggingTargetModel) {
		_currentTarget.value	=	nil
	}

	///

//	private let	_stackFrames		=	MutableArrayStorage<StackFrame>([])
//	private let	_frameVariables		=	MutableArrayStorage<FrameVariable>([])
	private let	_targets		=	MutableArrayStorage<DebuggingTargetModel>([])
	private let	_currentTarget		=	MutableValueStorage<DebuggingTargetModel?>(nil)

	private let	_lldbDebugger		=	LLDBDebugger()

	///

//	public class StackFrame {
//	}
//	public class FrameVariable {
//	}
}





public class DebuggingTargetModel: ModelSubnode<DebuggingModel> {

	public var debugging: DebuggingModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	///

	private init(LLDBTarget lldbTarget: LLDBTarget) {
		_lldbTarget	=	lldbTarget
	}

	///

	public var runnableCommands: ValueStorage<Set<DebuggingCommand>> {
		get {
			return	_runnableCommands
		}
	}

	public func run(command: DebuggingCommand) {
		switch command {
		case .Halt:
			halt()
		case .Pause:
			pause()
		case .Resume:
			resume()
		case .StepInto:
			stepInto()
		case .StepOut:
			stepOut()
		case .StepOver:
			stepOver()
		}
	}

	public func launch(workingDirectoryURL: NSURL? = nil) {
		_lldbTarget.launchProcessSimplyWithWorkingDirectory(workingDirectoryURL?.path ?? ".")
	}

	public func pause() {
		_lldbTarget.process.stop()
	}
	public func resume() {
		_lldbTarget.process.`continue`()
	}
	public func halt() {
		_lldbTarget.process.kill()
	}

	public func stepInto() {
		if let th = _findSuspendedThread() {
			th.stepInto()
		}
		else {
			assert(false)
		}
	}
	public func stepOut() {
		if let th = _findSuspendedThread() {
			th.stepOut()
		}
		else {
			assert(false)
		}
	}
	public func stepOver() {
		if let th = _findSuspendedThread() {
			th.stepOver()
		}
		else {
			assert(false)
		}
	}

	func selectFrameAtIndex(index: Int) {
		markUnimplemented()
		fatalErrorBecauseUnimplementedYet()
	}
	func deselectFrame() {
		markUnimplemented()
		fatalErrorBecauseUnimplementedYet()
	}
	func reloadFrameAtIndex(index: Int) {
		markUnimplemented()
		fatalErrorBecauseUnimplementedYet()
	}

	///

	private let	_lldbTarget		:	LLDBTarget
	private let	_runnableCommands	=	MutableValueStorage<Set<DebuggingCommand>>([])

	private func _findSuspendedThread() -> LLDBThread? {
		for th in _lldbTarget.process!.allThreads {
			if th.suspended {
				return	th
			}
		}
		return	nil
	}
}





//public class DebuggingThreadModel: ModelSubnode<DebuggingTargetModel> {
//
//	public var target: DebuggingTargetModel {
//		get {
//			assert(owner != nil)
//			return	owner!
//		}
//	}
//
//	///
//
//
//}





