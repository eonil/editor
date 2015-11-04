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

	public var currentFrame: LLDBFrame? {
		willSet {
			Event.WillChangeCurrentTarget.dualcastWithSender(self)
		}
		didSet {
			Event.DidChangeCurrentTarget.dualcastWithSender(self)
		}
	}

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

	public private(set) var targets: [DebuggingTargetModel] = []
	public private(set) var currentTarget: DebuggingTargetModel? {
		willSet {
			Event.WillChangeCurrentTarget.dualcastWithSender(self)
		}
		didSet {
			Event.DidChangeCurrentTarget.dualcastWithSender(self)
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
		_insertTargetWithEventCasting(m, at: targets.startIndex)
		return	m
	}
	public func deleteTarget(target: DebuggingTargetModel) {
		target.owner	=	nil
		if let idx = targets.indexOfValueByReferentialIdentity(target) {
			_lldbDebugger.deleteTarget(target.LLDBObject)
			_removeTargetWithEventCasting(at: idx)
		}
	}

	public func selectTarget(target: DebuggingTargetModel) {
		currentTarget	=	target
	}
	public func deselectTarget(target: DebuggingTargetModel) {
		currentTarget	=	nil
	}

	///

//	private let	_stackFrames		=	MutableArrayStorage<StackFrame>([])
//	private let	_frameVariables		=	MutableArrayStorage<FrameVariable>([])

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







	private func _insertTargetWithEventCasting(target: DebuggingTargetModel, at index: Int) {
		Event.WillChangeCurrentTarget.dualcastWithSender(self)
		targets.insert(target, atIndex: index)
		Event.DidChangeCurrentTarget.dualcastWithSender(self)
	}
	private func _removeTargetWithEventCasting(at index: Int) {
		Event.WillChangeCurrentTarget.dualcastWithSender(self)
		targets.removeAtIndex(index)
		Event.DidChangeCurrentTarget.dualcastWithSender(self)
	}
}
































