//
//  DebuggingModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon

public enum DebuggingCommand {
//	case Select(TargetInfo)
//	case Deselect
//
//	case Launch(TargetInfo)

	case Halt
	case Pause
	case Resume
	case StepOver
	case StepInto
	case StepOut

	public struct TargetInfo {
	}
}

public class DebuggingModel {

	internal weak var owner: WorkspaceModel?

	internal init() {
	}

	///

	var runnableCommands: ArrayStorage<DebuggingCommand> {
		get {
			return	_runnableCommands
		}
	}

	var stackFrames: ArrayStorage<StackFrame> {
		get {
			return	_stackFrames
		}
	}
	var frameVariables: ArrayStorage<FrameVariable> {
		get {
			return	_frameVariables
		}
	}

	func run(command: DebuggingCommand) {
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

	func launchCurrentTarget() {
		fatalErrorBecauseUnimplementedYet()
	}
	func pause() {
		fatalErrorBecauseUnimplementedYet()
	}
	func resume() {
		fatalErrorBecauseUnimplementedYet()
	}
	func halt() {
		fatalErrorBecauseUnimplementedYet()
	}

	func stepInto() {

	}
	func stepOut() {

	}
	func stepOver() {
		
	}

	func selectFrameAtIndex(index: Int) {
		fatalErrorBecauseUnimplementedYet()
	}
	func deselectFrame() {
		fatalErrorBecauseUnimplementedYet()
	}
	func reloadFrameAtIndex(index: Int) {
		fatalErrorBecauseUnimplementedYet()
	}

	///

	private let	_runnableCommands	=	MutableArrayStorage<DebuggingCommand>([])
	private let	_stackFrames		=	MutableArrayStorage<StackFrame>([])
	private let	_frameVariables		=	MutableArrayStorage<FrameVariable>([])

	///

	public class StackFrame {
	}
	public class FrameVariable {
	}
}
