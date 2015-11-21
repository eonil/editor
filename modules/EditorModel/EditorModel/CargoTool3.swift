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
		_runCargoWithParameters(path, command: "cargo new --verbose \(newDirectoryName) \(asExecutable ? "--bin" : "")")
	}
	func runBuild(path path: String) {
		_runCargoWithParameters(path, command: "cargo build --verbose")
	}
	func runClean(path path: String) {
		_runCargoWithParameters(path, command: "cargo clean --verbose")
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
//		_executor.execute("export PATH=$PATH:~/.multirust/toolchains/stable/bin")
//		_executor.execute("export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.multirust/toolchains/stable/lib")
//		_executor.execute("export DYLD_FRAMEWORK_PATH=$DYLD_FRAMEWORK_PATH:~/.multirust/toolchains/stable/lib")
//		_executor.execute("export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:~/.multirust/toolchains/stable/lib")
//		_executor.execute("export DYLD_FALLBACK_LIBRARY_PATH=$DYLD_FALLBACK_LIBRARY_PATH:~/.multirust/toolchains/stable/lib")

//		_executor.execute("export PATH=$PATH:~/.multirust/toolchains/1.2.0/bin")
//		_executor.execute("export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:~/.multirust/toolchains/1.2.0/lib")
//		_executor.execute("export PATH=$PATH:~/Unix/multirust/bin")
//		_executor.execute("export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:~/Unix/multirust/lib")
//		_executor.execute("cd \(workingDirectoryPath)")
//		_executor.execute("export DYLD_FALLBACK_LIBRARY_PATH=\"$HOME/Unix/homebrew/lib\"")
//		_executor.execute("cc --version")
//		_executor.execute("env")
//		_executor.execute("rustc --version")
		_executor.execute(command)
//		let	cmd	=	"\"cc\" \"-m64\" \"-L\" \"/Users/Eonil/.multirust/toolchains/stable/lib/rustlib/x86_64-apple-darwin/lib\" \"/Users/Eonil/Documents/Editor2Test/a4/target/debug/a4.0.o\" \"-o\" \"/Users/Eonil/Documents/Editor2Test/a4/target/debug/a4\" \"-Wl,-dead_strip\" \"-nodefaultlibs\" \"/Users/Eonil/.multirust/toolchains/stable/lib/rustlib/x86_64-apple-darwin/lib/libstd-1bf6e69c.rlib\" \"/Users/Eonil/.multirust/toolchains/stable/lib/rustlib/x86_64-apple-darwin/lib/libcollections-1bf6e69c.rlib\" \"/Users/Eonil/.multirust/toolchains/stable/lib/rustlib/x86_64-apple-darwin/lib/librustc_unicode-1bf6e69c.rlib\" \"/Users/Eonil/.multirust/toolchains/stable/lib/rustlib/x86_64-apple-darwin/lib/librand-1bf6e69c.rlib\" \"/Users/Eonil/.multirust/toolchains/stable/lib/rustlib/x86_64-apple-darwin/lib/liballoc-1bf6e69c.rlib\" \"/Users/Eonil/.multirust/toolchains/stable/lib/rustlib/x86_64-apple-darwin/lib/liballoc_jemalloc-1bf6e69c.rlib\" \"/Users/Eonil/.multirust/toolchains/stable/lib/rustlib/x86_64-apple-darwin/lib/liblibc-1bf6e69c.rlib\" \"/Users/Eonil/.multirust/toolchains/stable/lib/rustlib/x86_64-apple-darwin/lib/libcore-1bf6e69c.rlib\" \"-L\" \"/Users/Eonil/Documents/Editor2Test/a4/target/debug\" \"-L\" \"/Users/Eonil/Documents/Editor2Test/a4/target/debug/deps\" \"-L\" \"/Users/Eonil/.multirust/toolchains/stable/lib/rustlib/x86_64-apple-darwin/lib\" \"-L\" \"/Users/Eonil/Documents/Editor2Test/a4/.rust/lib/x86_64-apple-darwin\" \"-L\" \"/Users/Eonil/Documents/Editor2Test/a4/lib/x86_64-apple-darwin\" \"-l\" \"System\" \"-l\" \"pthread\" \"-l\" \"c\" \"-l\" \"m\" \"-l\" \"compiler-rt\""
//		_executor.execute(cmd)
//		let	cmd	=	"rustc src/main.rs --crate-name a4 --crate-type bin -g --out-dir /Users/Eonil/Documents/Editor2Test/a4/target/debug --emit=dep-info,link -L dependency=/Users/Eonil/Documents/Editor2Test/a4/target/debug -L dependency=/Users/Eonil/Documents/Editor2Test/a4/target/debug/deps"
//		_executor.execute(cmd)
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
		Debug.assertMainThread()
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
		Debug.assertMainThread()
		dispatch_semaphore_wait(_waitSema, DISPATCH_TIME_FOREVER)
		if _shouldBeStateDone.state {
			if _transition.state == .Running {
				_transition.state	=	.Cleaning
				_transition.state	=	.Done
			}
		}
	}
	func execute(command: String) {
		Debug.assertMainThread()
		precondition(_transition.state == .Running, "You can execute only on a running executor.")
		_shell.standardInput.writeUTF8String(command)
		_shell.standardInput.writeUTF8String("\n")
	}
	func terminate() {
		Debug.assertMainThread()
		precondition(_transition.state == .Running)
		_transition.state	=	.Cleaning
		_shell.terminate()
	}
	func kill() {
		Debug.assertMainThread()
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
			var	s	=	""
			let	r	=	_readBytes(_BUFFER_SIZE_IN_BYTES, fromFileHandle: _shell.standardOutput)
			switch r {
			case .Bytes(let bs):
				for b in bs {
					s.appendContentsOf(_stdoutUTF8Decoder.push(b))
				}
				dispatchToMainQueueAsynchronously { [weak self] in
					assert(self!.onStandardOutput != nil, "Expects programmer to set this.")
					self!.onStandardOutput?(s)
				}
				continue

			case .EOF:
				break
			}
			break
		}
		dispatchToMainQueueAsynchronously { [weak self] in
			self!._stdoutEOF.state	=	true
		}
	}

	private func _runReadingStandardErrorOnNonMainThread() {
		Debug.assertNonMainThread()
		while true {
			var	s	=	""
			let	r	=	_readBytes(_BUFFER_SIZE_IN_BYTES, fromFileHandle: _shell.standardError)
			switch r {
			case .Bytes(let bs):
				for b in bs {
					s.appendContentsOf(_stderrUTF8Decoder.push(b))
				}
				dispatchToMainQueueAsynchronously { [weak self] in
					assert(self!.onStandardError != nil, "Expects programmer to set this.")
					self!.onStandardError?(s)
				}
				continue

			case .EOF:
				break
			}
			break
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
					dispatchToSleepAndContinueInNonMainQueue(0.1) { [weak self] in
						self!._onShellTerminationOnNonMainThread()
					}
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

private func _readBytes(count: Int, fromFileHandle: NSFileHandle) -> _ReadingResult {
	let	d	=	fromFileHandle.readDataOfLength(count)
	if d.length == 0 {
		return	.EOF
	}

	var	buffer	=	[UInt8]()
	var	p	=	unsafeBitCast(d.bytes, UnsafePointer<UInt8>.self)

	buffer.reserveCapacity(d.length)
	for _ in 0..<d.length {
		buffer.append(p.memory)
		p++
	}
	return	.Bytes(buffer)
}











private let	_BUFFER_SIZE_IN_BYTES	=	1024



