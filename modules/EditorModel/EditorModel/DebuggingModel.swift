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

public class DebuggingModel {

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

	private let	_stackFrames	=	MutableArrayStorage<StackFrame>([])
	private let	_frameVariables	=	MutableArrayStorage<FrameVariable>([])

	///

	public class StackFrame {
	}
	public class FrameVariable {
	}
}
