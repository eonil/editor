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

	init(rootDirectoryURL: NSURL) {
		precondition(rootDirectoryURL.scheme == "file")
		precondition(rootDirectoryURL.path != nil)
		_rootDir			=	rootDirectoryURL
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
	func runNew() {
		if let p = _pathToParentDirectoryOfProjectRootDirectory() {
			//	File system is always asynchronous, and no one can have truly exclusive access.
			//	Then we cannot make any assume on file system. Just try and take the result.
			_runCargoWithParameters(p, parameters: ["new"])
		}
		else {
			_state.value	=	.Error
			_errors.append("Cannot resolve the destination directory.")
		}
	}
	func runBuild() {
		_runCargoWithParameters(_pathToProjectRootDirectory(), parameters: ["build"])
	}
	func runClean() {
		_runCargoWithParameters(_pathToProjectRootDirectory(), parameters: ["clean"])
	}
	func runDoc() {
		markUnimplemented()
	}
	func runTest() {
		markUnimplemented()
	}
	func runBench() {
		markUnimplemented()
	}
	func runUpdate() {
		markUnimplemented()
	}
	func runSearch() {
		markUnimplemented()
	}

	func stop() {
		_task.terminate()
	}
//	func halt() {
//		_isTerminated	=	true
//	}

	///

	private let	_rootDir	:	NSURL
	private let	_task		=	NSTask()
	private var	_isTerminated	=	false
	private let	_state		=	MutableValueStorage<State>(.Idle)
	private let	_errors		=	MutableArrayStorage<String>([])
	private let	_log		=	MutableValueStorage<String>("")

	private let	_outputPipe	=	NSPipe()

	private func _pathToParentDirectoryOfProjectRootDirectory() -> String? {
		if let u1 = _rootDir.URLByDeletingLastPathComponent {
			return	u1.path!
		}
		else {
			return	nil
		}
	}
	private func _pathToProjectRootDirectory() -> String {
		return	_rootDir.path!
	}
	private func _runCargoWithParameters(workingDirectoryPath: String, parameters: [String]) {
		_task.currentDirectoryPath	=	workingDirectoryPath
		_task.launchPath		=	"cargo"
		_task.arguments			=	parameters
		_task.launch()
	}
	private func _handleOutput(data: NSData) {
		markUnimplemented()
	}
	private func _handleTermination() {
		_state.value			=	.Done
	}

}







