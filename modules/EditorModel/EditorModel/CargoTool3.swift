//
//  CargoTool3.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/11/18.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon

class CargoTool3 {

	enum State {
		case Ready
		case Running
		case Cleaning		//<	Death declared, but not yet actually dead.
		case Done
	}

	enum Event {
		case Launch		//<	Ready -> Running
		case Clean		//<	Running -> Cleaning
		case Exit		//<	Cleaning -> Done
	}

	static func defaultTransitionRules() -> [Transition<State, Event>.Rule] {
		return	[
			(.Ready,	.Running,	.Launch),
			(.Running,	.Cleaning,	.Clean),
			(.Cleaning,	.Done,		.Exit),
		]
	}





	///

	var state: State {
		get {
			return	_transition.state
		}
	}

	var onEvent: (Event->())? {
		didSet {
			_transition.onEvent	=	onEvent
		}
	}

	var onStandardOutput: (String->())? {
		didSet {
			_executor.onStandardOutput	=	onStandardOutput
		}
	}
	var onStandardError: (String->())? {
		didSet {
			_executor.onStandardError	=	onStandardError
		}
	}




	init() {
		_executor.onEvent	=	{ [weak self] in
			self!._transition.transit($0)
		}
	}
	deinit {
	}


	/// - Parameters:
	///	- rootDirectoryURL:
	///		A URL to a directory that will become root directory of
	///		a cargo project. This directory must not exists.
	///
	///
	func runNew(path path: String, newDirectoryName: String, asExecutable: Bool) {
		//	File system is always asynchronous, and no one can have truly exclusive access.
		//	Then we cannot make any assume on file system. Just try and take the result.
		_runCargoWithParameters(path, command: "cargo new -v \(newDirectoryName) \(asExecutable ? "--bin" : "")")
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
		_executor.terminate()
	}
	//	func halt() {
	//		_isTerminated	=	true
	//	}

	func waitForCompletion() {
		_executor.wait()
	}





	///

	private let _executor	=	_FileOutputWaitingExecutor()
	private let _transition	=	Transition(.Ready, CargoTool3.defaultTransitionRules())

	private func _runCargoWithParameters(workingDirectoryPath: String, command: String) {
		// Single command execution is an intentional design to get a proper exit code.
		_executor.launch(workingDirectoryPath)
		_executor.execute(command)
		_executor.execute("exit $?")
	}

}






























private class _FileOutputWaitingExecutor {

	typealias	State	=	CargoTool3.State
	typealias	Event	=	CargoTool3.Event

	var onStandardOutput: (String->())?		//< It's guaranteed that this won't be called anymore since `onTermination` has been called.
	var onStandardError: (String->())?		//< It's guaranteed that this won't be called anymore since `onTermination` has been called.






	init() {
	}
	deinit {
		// Buffer state can be dirty if the remote process exited by crash.
		let	MSG	=	"You're responsible to keep this object alive until this remote shell exits."
		assert(_isShellTerminated.state == true, MSG)
		assert(_stdoutEOF.state == true, MSG)
		assert(_stderrEOF.state == true, MSG)
	}

	var state: State {
		get {
			return	_transition.state
		}
	}
	var onEvent: (Event->())? {
		didSet {
			_transition.onEvent	=	onEvent
		}
	}

	func launch(workingDirectoryPath: String) {
		precondition(_transition.state == .Ready)
		_transition.state	=	.Running
		_shell.terminationHandler	=	{ [weak self] in
			dispatchToNonMainQueueAsynchronously { [weak self] in
				self!._onShellTerminationOnNonMainThread()
			}
		}
		_shell.launch(workingDirectoryPath: workingDirectoryPath)

		dispatchToNonMainQueueAsynchronously { [weak self] in
			self!._runReadingStandardOutputOnNonMainThread()
		}
		dispatchToNonMainQueueAsynchronously { [weak self] in
			self!._runReadingStandardErrorOnNonMainThread()
		}
	}
	/// Blocks calling thread (main thread) until `isDone == true`.
	/// `isDone == true` when this function returns.
	/// `onDone` will be called right after this function returned.
	func wait() {
		dispatch_semaphore_wait(_waitSema, DISPATCH_TIME_FOREVER)
		if _shouldBeStateDone.state {
			if _transition.state == .Running {
				_transition.state	=	.Cleaning
				_transition.state	=	.Done
			}
		}
	}
	func execute(command: String) {
		precondition(_transition.state == .Running, "You can execute only on a running executor.")
		_shell.standardInput.writeUTF8String(command)
		_shell.standardInput.writeUTF8String("\n")
	}
	func terminate() {
		precondition(_transition.state == .Running)
		_transition.state	=	.Cleaning
		_shell.terminate()
	}
	func kill() {
		precondition(_transition.state == .Running)
		_transition.state	=	.Cleaning
		_shell.kill()
	}








	///

	private let _transition		=	Transition(.Ready, CargoTool3.defaultTransitionRules())
	private let _shell		=	ShellTaskExecutionController()
	private var _stdoutUTF8Decoder	=	_UTF8Decoder()
	private var _stderrUTF8Decoder	=	_UTF8Decoder()
	private var _isShellLaunched	=	AtomicBool(false)
	private var _isShellTerminated	=	AtomicBool(false)
	private var _stdoutEOF		=	AtomicBool(false)
	private var _stderrEOF		=	AtomicBool(false)
	private let _waitSema		=	dispatch_semaphore_create(0)!
	private var _shouldBeStateDone	=	AtomicBool(false)

	private func _runReadingStandardOutputOnNonMainThread() {
		Debug.assertNonMainThread()
		while true {
			if let b = readOneByteFromFileHandle(_shell.standardOutput) {
				let	s	=	_stdoutUTF8Decoder.push(b)
				guard s != "" else {
					continue
				}
				dispatchToMainQueueAsynchronously { [weak self] in
					assert(self!.onStandardOutput != nil, "Expects programmer to set this.")
					self!.onStandardOutput?(s)
				}
			}
			else {
				break
			}
		}
		dispatchToMainQueueAsynchronously { [weak self] in
			self!._stdoutEOF.state	=	true
		}
	}

	private func _runReadingStandardErrorOnNonMainThread() {
		Debug.assertNonMainThread()
		while true {
			if let b = readOneByteFromFileHandle(_shell.standardError) {
				let	s	=	_stdoutUTF8Decoder.push(b)
				guard s != "" else {
					continue
				}
				dispatchToMainQueueAsynchronously { [weak self] in
					assert(self!.onStandardError != nil, "Expects programmer to set this.")
					self!.onStandardError?(s)
				}
			}
			else {
				break
			}
		}
		dispatchToMainQueueAsynchronously { [weak self] in
			self!._stderrEOF.state	=	true
		}
	}

	private func _onShellTerminationOnNonMainThread() {
		Debug.assertNonMainThread()
		dispatchToNonMainQueueAsynchronously { [weak self] in
			// We cannot roun-trip to main thread because it can be blocked by `wait` at this point.
			// So, we made all flags atomic.
			self!._isShellTerminated.state	=	true
			if self!._stdoutEOF.state && self!._stderrEOF.state {
				self!._shouldBeStateDone.state	=	true		//< We need this because main thread can be blocked by `wait` call.
				dispatch_semaphore_signal(self!._waitSema)
				dispatchToMainQueueAsynchronously { [weak self] in
					if self!._transition.state == .Running {
						self!._transition.state	=	.Cleaning
						self!._transition.state	=	.Done
					}
				}
			}
			else {
				// Wait more...
				dispatchToNonMainQueueAsynchronously { [weak self] in
					sleep(1)
					self!._onShellTerminationOnNonMainThread()
				}
			}
		}
	}

}















private struct _UTF8Decoder {
	mutating func push(byte: UInt8) -> String {
		var	buffer	=	String()
		var	g	=	GeneratorOfOne(byte)
		while true {
			switch utf8.decode(&g) {
			case .EmptyInput:
				utf8	=	UTF8()
				return	buffer

			case .Error:
				return	""

			case .Result(let codePoint):
				buffer.append(codePoint)
			}
		}
	}
	var	utf8	=	UTF8()
}
private enum _ReadingResult {
	case EOF
	case Bytes([UInt8])
}

/// Returns `nil` on EOF.
private func readOneByteFromFileHandle(fileHandle: NSFileHandle) -> UInt8? {
	let	d	=	fileHandle.readDataOfLength(1)
	if d.length == 1 {
		let	p	=	unsafeBitCast(d.bytes, UnsafePointer<UInt8>.self)
		print(p.memory)
		return	p.memory
	}
	return	nil
}










