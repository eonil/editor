//
//  ExecutionStateInspectionModel.swift
//  EditorDebugUI
//
//  Created by Hoon H. on 2015/08/28.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper
import MulticastingStorage
import EditorCommon

/// Hosts execution-state model.
///
/// This is designed to provide a way to hide `debugger` property
/// from external interface of the model. You instantiate this 
/// object instead of the model, and use the exposed model object
/// and `debugger` property to set the debugger. And you can hide
/// instance of this object.
public struct ExecutionStateInspectionModelHost {
	public init() {
	}
	/// This object owns supplied proxy object,
	/// so you don't have to keep it in your side.
	public var data: LLDBDebugger? {
		willSet {
		}
		didSet {
			model.data	=	data
		}
	}
	public let	model	=	ExecutionStateInspectionModel()
}

/// A outline tree that represents program execution states
/// from processes to stack frames. 
///
/// This also manages default-selections of each nodes.
///
public class ExecutionStateInspectionModel {

	private init() {
	}

	///

	public let selection	=	ExecutionStateSelectionModel()

	///

	internal var data: LLDBDebugger?

	///

	public var processes: ArrayStorage<ProcessNode> {
		get {
			return	_processes
		}
	}

	public func run() {
		assert(data != nil)
		assert(_isRunning == false)

		var	ps	=	[ProcessNode]()
		for t in data!.allTargets {
			if let p = t.process {
				let	p1	=	ProcessNode()
				p1.data		=	p
				ps.append(p1)
			}
		}
		_processes.insert(ps, atIndex: 0)

		selection.owner	=	self

		_isRunning	=	true
	}
	public func halt() {
		assert(data != nil)
		assert(_isRunning == true)

		_isRunning	=	false
		
		selection.owner	=	nil

		_processes.delete(_processes.array.wholeRange)
	}

	///

//	public var currentFrame: ValueStorage<FrameNode?> {
//		get {
//			return	_currentFrame
//		}
//	}

	///

	public var defaultProcess: ValueStorage<ProcessNode?> {
		get {
			return	_defaultProcess
		}
	}
	public func selectDefaultProcess(process: ProcessNode) {
		assert(_defaultProcess.value == nil)
		_defaultProcess.value	=	process
	}

	public func deselectDefaultProcess() {
		assert(_defaultProcess.value != nil)
		_defaultProcess.value	=	nil
	}

	///

	private var	_isRunning	=	false
	private let	_processes	=	MutableArrayStorage<ProcessNode>([])
	private let	_defaultProcess	=	MutableValueStorage<ProcessNode?>(nil)
	private let	_currentFrame	=	MutableValueStorage<FrameNode?>(nil)
	private let	_currentValue	=	MutableValueStorage<FrameNode?>(nil)
}








public class ProcessNode {

	weak var owner: ExecutionStateInspectionModel?

	var inspection: ExecutionStateInspectionModel {
		get {
			return	owner!
		}
	}

	///

	internal var data: LLDBProcess?

	public var threads: ArrayStorage<ThreadNode> {
		get {
			return	_threads
		}
	}

	public func run() {
		assert(data != nil)
		assert(_isRunning == true)
		_isRunning	=	true
	}
	public func halt() {
		assert(data != nil)
		assert(_isRunning == true)
		_isRunning	=	false
	}

	///

	public var defaultThread: ValueStorage<ThreadNode?> {
		get {
			return	_defaultThread
		}
	}
	public func selectDefaultThread(thread: ThreadNode) {
		assert(_defaultThread.value == nil)
		_defaultThread.value	=	thread
	}

	public func deselectDefaultThread() {
		assert(_defaultThread.value != nil)
		_defaultThread.value	=	nil
	}

	///

	private var	_isRunning	=	false
	private let	_threads	=	MutableArrayStorage<ThreadNode>([])
	private let	_defaultThread	=	MutableValueStorage<ThreadNode?>(nil)
}

public class ThreadNode {

	weak var owner: ProcessNode?

	var process: ProcessNode {
		get {
			return	owner!
		}
	}

	///

	var data: LLDBThread?

	public var frames: ArrayStorage<FrameNode> {
		get {
			return	_frames
		}
	}

	public func run() {
		assert(data != nil)
		assert(_isRunning == true)
		_isRunning	=	true
	}
	public func halt() {
		assert(data != nil)
		assert(_isRunning == true)
		_isRunning	=	false
	}

	///

	public var defaultFrame: ValueStorage<FrameNode?> {
		get {
			return	_defaultFrame
		}
	}
	public func selectDefaultFrame(frame: FrameNode) {
		assert(_defaultFrame.value == nil)
		_defaultFrame.value	=	frame
	}

	public func deselectDefaultFrame() {
		assert(_defaultFrame.value != nil)
		_defaultFrame.value	=	nil
	}

	///

	private var	_isRunning	=	false
	private let	_frames		=	MutableArrayStorage<FrameNode>([])
	private let	_defaultFrame	=	MutableValueStorage<FrameNode?>(nil)
}

/// Manages variable tree informations in memory in tree form.
///
/// `NSOutlineView` uses object pointer for identity check.
/// So we cannot use `LLDBValue` object as is becuase it's just a temporary proxy
/// and does not provide pointer level identity.
/// That's why we need to make `VariableTreeNode`.
public class FrameNode {

	weak var owner: ThreadNode?

	var thread: ThreadNode {
		get {
			return	owner!
		}
	}

	///
	
	public var data: LLDBFrame? {
		willSet {
			if let _ = data {
				_variables.delete(_variables.array.wholeRange)
			}
			assert(_variables.array.count == 0)
		}
		didSet {
			assert(_variables.array.count == 0)
			if let data = data {
				func makeSubvariableFromSubdata(subdata: LLDBValue) -> VariableNode {
					let	v	=	VariableNode()
					v.owner		=	self
					v.supervariable	=	nil
					v.data		=	subdata
					return	v
				}
				let	subdata		=	data.variablesWithArguments(true, locals: true, statics: true, inScopeOnly: true, useDynamic: LLDBDynamicValueType.DynamicCanRunTarget)?.allAvailableValues ?? []
				let	subvars		=	subdata.map(makeSubvariableFromSubdata)
				_variables.insert(subvars, atIndex: 0)
			}
		}
	}

	public var variables: ArrayStorage<VariableNode> {
		get {
			return	_variables
		}
	}

	public func run() {
		assert(data != nil)
		assert(_isRunning == true)
		_isRunning	=	true
	}
	public func halt() {
		assert(data != nil)
		assert(_isRunning == true)
		_isRunning	=	false
	}

	///

	private var	_isRunning	=	false
	private var	_variables	=	MutableArrayStorage<VariableNode>([])
}

public class VariableNode {

	weak var owner: FrameNode?

	var frame: FrameNode {
		get {
			return	owner!
		}
	}

	///

	public private(set) weak var supervariable: VariableNode?

	public var subvariables: ArrayStorage<VariableNode> {
		get {
			return	_subvariables
		}
	}

	///

	internal var data: LLDBValue? {
		didSet {
		}
	}
	public func run() {
		assert(data != nil)
		assert(_isRunning == true)
		_isRunning	=	true
	}
	public func halt() {
		assert(data != nil)
		assert(_isRunning == true)
		_isRunning	=	false
	}

	/// Reloads snapshot of current value subnode states.
	public func reloadSubnodes() {
		_subvariables.delete(_subvariables.array.wholeRange)
		func makeSubvariableFromSubdata(subdata: LLDBValue) -> VariableNode {
			let	v	=	VariableNode()
			v.owner		=	owner
			v.supervariable	=	self
			v.data		=	subdata
			return	v
		}
		let	subdata		=	data?.allAvailableChildren ?? []
		let	subvars		=	subdata.map(makeSubvariableFromSubdata)
		_subvariables.insert(subvars, atIndex: 0)
	}

	///

	private var	_isRunning	=	false
	private let	_subvariables	=	MutableArrayStorage<VariableNode>([])
}












