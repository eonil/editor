//
//  OperationModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/31.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage

/// Represents state of a long running (asynchronous, or done over multiple frames) processing.
///
public class Operation {
	public enum State {
		case Ready
		case Booting
		case Running
		case Halting
	}

	public var isRunning: ValueStorage<Bool> {
		get {
			return	_isRunning
		}
	}
	public var completion: CompletionChannel {
		get {
			return	_completion
		}
	}

	///

	private let	_isRunning	=	MutableValueStorage<Bool>(false)
	private let	_completion	=	CompletionQueue()
}

public class ControllableOperation: Operation {
	public func run() {

	}
	public func halt() {

	}
	public func reset() {

	}
}