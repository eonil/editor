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

public class DebuggingModel: ModelSubnode<WorkspaceModel>, BroadcastingModelType {

	internal override init() {
		Debug.log("DebuggingModel.init")
	}
	deinit {
		Debug.log("DebuggingModel.deinit")
	}

	///

	public let event = EventMulticast<Event>()

	public var workspace: WorkspaceModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	///

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		_install()
	}
	override func willLeaveModelRoot() {
		_deinstall()
		super.willLeaveModelRoot()
	}

	///

	public let	waiter		=	DebuggingEventWaiter()
	public let	selection	=	ExecutionStateSelectionModel()
//	public let	inspection	=	ExecutionStateInspectionModel()

	///

	public var debugger: LLDBDebugger {
		get {
			return	_lldbDebugger
		}
	}

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
	public var currentTarget: ValueStorage2<DebuggingTargetModel?> {
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
		m.owner		=	self
		_targets.insert([m], atIndex: _targets.array.startIndex)
		return	m
	}
	public func deleteTarget(target: DebuggingTargetModel) {
		target.owner	=	nil
		if let idx = _targets.array.indexOfValueByReferentialIdentity(target) {
			_lldbDebugger.deleteTarget(target.LLDBObject)
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
	private let	_currentTarget		=	MutableValueStorage2<DebuggingTargetModel?>(nil)

	private let	_lldbDebugger		=	LLDBDebugger()
	private let	_eventWaiter		=	DebuggingEventWaiter()

	///

	private func _install() {
		waiter.owner			=	self
		selection.owner			=	self
//		inspection.owner		=	self

	}
	private func _deinstall() {
//		inspection.owner		=	nil
		selection.owner			=	nil
		waiter.owner			=	nil
	}

//	public class StackFrame {
//	}
//	public class FrameVariable {
//	}

}
































