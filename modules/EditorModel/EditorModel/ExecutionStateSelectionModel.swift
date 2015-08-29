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

public class ExecutionStateSelectionModel: ModelSubnode<DebuggingModel> {

	public var debug: DebuggingModel {
		get {
			return	owner!
		}
	}

	///

	public var frame: ValueStorage<LLDBFrame?> {
		get {
			assert(owner != nil)
			return	_frame
		}
	}
	public func setFrame(frame: LLDBFrame?) {
		assert(owner != nil)
		_frame.value	=	frame
	}

	///

	public var value: ValueStorage<LLDBValue?> {
		get {
			assert(owner != nil)
			return	_value
		}
	}
	public func selectValue(variable: LLDBValue) {
		assert(owner != nil)
		assert(_value.value == nil)
		_value.value	=	variable
	}
	public func deselectValue() {
		assert(owner != nil)
		assert(_frame.value != nil)
		_value.value	=	nil
	}

	///

	private let	_frame		=	MutableValueStorage<LLDBFrame?>(nil)
	private let	_value		=	MutableValueStorage<LLDBValue?>(nil)
}










