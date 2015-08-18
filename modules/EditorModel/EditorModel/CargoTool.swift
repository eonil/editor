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
		case Ready
		case Running
		case Error
		case Done
	}

	///

	init() {
		_installObservers()
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
	var completion: CompletionChannel {
		get {
			return	_cmplq
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
		_runCargoWithParameters(path, command: "cargo new -v \(newDirectoryName)")
	}
	func runBuild(path path: String) {
		_runCargoWithParameters(path, command: "cargo build -v")
	}
	func runClean(path path: String) {
		_runCargoWithParameters(path, command: "cargo clean -v")
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
		_shell.terminate()
	}
//	func halt() {
//		_isTerminated	=	true
//	}

	///

	private let	_shell		=	ShellTaskExecutionController()
	private var	_isTerminated	=	false

	private let	_state		=	MutableValueStorage<State>(.Ready)
	private let	_errors		=	MutableArrayStorage<String>([])
	private let	_log		=	MutableValueStorage<String>("")
	private let	_cmplq		=	CompletionQueue()

	private let	_stdoutStrDisp	=	UTF8StringDispatcher()
	private var	_stdoutLineDisp	=	LineDispatcher()

	private let	_stderrStrDisp	=	UTF8StringDispatcher()
	private var	_stderrLineDisp	=	LineDispatcher()

	///

	private func _runCargoWithParameters(workingDirectoryPath: String, command: String) {
		assert(_isTerminated == false)

		_installObservers()
		_setState(.Running)
		_shell.launch(workingDirectoryPath: workingDirectoryPath)
		_shell.standardInput.writeUTF8String("\(command)\n")
		_shell.standardInput.writeUTF8String("exit $?\n")
//		_shell.waitUntilExit()
//		assert(_shell.terminationStatus == 0)
	}
	private func _handleOutput(data: NSData) {
		_stdoutStrDisp.push(data)
	}
	private func _handleError(data: NSData) {
		_stderrStrDisp.push(data)
	}
	private func _handleTermination() {
		_isTerminated	=	true
		_setState(.Done)
		_deinstallObservers()
		_cmplq.cast()
	}

	private func _setState(s: State) {
		_state.value	=	s
		onDidSetState?()
	}

	private func _installObservers() {
		_shell.terminationHandler	=	{ [weak self] task in
			dispatchToMainQueueAsynchronously { [weak self] in
				self?._handleTermination()
			}
		}

		_shell.standardOutput.readabilityHandler	=	{ [weak self] in self?._handleOutput($0.availableData) }
		_stdoutStrDisp.onString				=	{ [weak self] in self?._stdoutLineDisp.push($0) }
		_stdoutLineDisp.onLine				=	{ [weak self] in print($0) }

		_shell.standardError.readabilityHandler		=	{ [weak self] in self?._handleError($0.availableData) }
		_stderrStrDisp.onString				=	{ [weak self] in self?._stderrLineDisp.push($0) }
		_stderrLineDisp.onLine				=	{ [weak self] in print($0) }
	}
	private func _deinstallObservers() {
		_stderrLineDisp.onLine				=	nil
		_stderrStrDisp.onString				=	{ _ in return }
		_shell.standardError.readabilityHandler		=	nil

		_stdoutLineDisp.onLine				=	nil
		_stdoutStrDisp.onString				=	{ _ in return }
		_shell.standardOutput.readabilityHandler	=	nil
	}
}








