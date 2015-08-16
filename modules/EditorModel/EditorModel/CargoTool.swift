//
//  CargoToo.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon

/// Executes Cargo.
///
/// This is disposable (one-time use only) tool that
/// executes Cargo.
/// This tool assumes you already have installed Rust and Cargo,
/// and they are executable via command line.
///
class CargoTool {

	enum State {
		case Idle
		case Running
		case Error
		case Done
	}

	///

	init() {
		_task.terminationHandler	=	{ [weak self] task in
			dispatchToMainQueueAsynchronously { [weak self] in
				self?._handleTermination()
			}
		}
		_outputPipe.fileHandleForReading.readabilityHandler	=	{ [weak self] handle in
			self?._handleOutput(handle.availableData)
		}
	}
	deinit {
		assert(_isTerminated == true)
	}

	///

	var onDidSetState: (()->())?

	var state: ValueStorage<State> {
		get {
			return	_state
		}
	}
	var errors: ArrayStorage<String> {
		get {
			return	_errors
		}
	}
	var log: ValueStorage<String> {
		get {
			return	_log
		}
	}

	///

	/// - Parameters:
	///	- rootDirectoryURL:
	///		A URL to a directory that will become root directory of
	///		a cargo project. This directory must not exists.
	///
	///
	func runNew(path path: String, newDirectoryName: String) {
		//	File system is always asynchronous, and no one can have truly exclusive access.
		//	Then we cannot make any assume on file system. Just try and take the result.
		_runCargoWithParameters(path, parameters: ["new", newDirectoryName])
	}
	func runBuild(path path: String) {
		_runCargoWithParameters(path, parameters: ["build"])
	}
	func runClean(path path: String) {
		_runCargoWithParameters(path, parameters: ["clean"])
	}
	func runDoc(path path: String) {
		markUnimplemented()
	}
	func runTest(path path: String) {
		markUnimplemented()
	}
	func runBench(path path: String) {
		markUnimplemented()
	}
	func runUpdate(path path: String) {
		markUnimplemented()
	}
	func runSearch(path path: String) {
		markUnimplemented()
	}

	/// - Parameters:
	///	- haltTimeout:
	///		If this is non-nil value, this method will halt (sends `SIGNKILL`)
	///		the `cargo` process after waiting for this. If this is `nil`, this
	///		method will not try to halt and expects the program always quit 
	///		gracefully.
	func stop(haltTimeout: NSTimeInterval? = nil) {
		markUnimplemented()
		assert(haltTimeout == nil, "Non-nil case is not implemented yet...")
		_task.terminate()
	}
//	func halt() {
//		_isTerminated	=	true
//	}

	///

	private let	_task		=	NSTask()
	private var	_isTerminated	=	false
	private let	_state		=	MutableValueStorage<State>(.Idle)
	private let	_errors		=	MutableArrayStorage<String>([])
	private let	_log		=	MutableValueStorage<String>("")

	private let	_outputPipe	=	NSPipe()

	///

	private func _runCargoWithParameters(workingDirectoryPath: String, parameters: [String]) {
		markUnimplemented()
		_task.currentDirectoryPath	=	workingDirectoryPath
//		_task.launchPath		=	ToolLocationResolver.cargoToolLocation()
		_task.launchPath		=	"/Users/Eonil/Unix/homebrew/bin/cargo"
		_task.arguments			=	parameters
		_task.launch()
	}
	private func _handleOutput(data: NSData) {
		markUnimplemented()
	}
	private func _handleTermination() {
		_setState(.Done)
	}

	private func _setState(s: State) {
		_state.value	=	s
		onDidSetState?()
	}

}








