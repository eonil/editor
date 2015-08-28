//
//  ExecutionStateSelectionModel.swift
//  EditorDebugUI
//
//  Created by Hoon H. on 2015/08/28.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper
import MulticastingStorage
import EditorCommon

public class ExecutionStateSelectionModel {
	internal weak var owner: ExecutionStateInspectionModel?

	public var inspection: ExecutionStateInspectionModel {
		get {
			return	owner!
		}
	}

	///

	public var frame: ValueStorage<FrameNode?> {
		get {
			assert(owner != nil)
			return	_frame
		}
	}
	public func selectFrame(frame: FrameNode) {
		assert(owner != nil)
		assert(_frame.value == nil)
		assert(frame.thread.process.inspection === inspection)

		_frame.value	=	frame
	}
	public func deselectFrame() {
		assert(owner != nil)
		assert(_frame.value != nil)
		_frame.value	=	nil
	}

	///

	public var variable: ValueStorage<VariableNode?> {
		get {
			assert(owner != nil)
			return	_variable
		}
	}
	public func selectVariable(variable: VariableNode) {
		assert(owner != nil)
		assert(_variable.value == nil)
		assert(variable.frame.thread.process.inspection === inspection)
		_variable.value	=	variable
	}
	public func deselectVariable() {
		assert(owner != nil)
		assert(_frame.value != nil)
		_variable.value	=	nil
	}

	///

	private let	_frame		=	MutableValueStorage<FrameNode?>(nil)
	private let	_variable	=	MutableValueStorage<VariableNode?>(nil)
}










