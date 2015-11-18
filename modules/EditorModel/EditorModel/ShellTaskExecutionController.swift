//
//  ShellTaskExecutionController.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/16.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon

/// Runs a non-interactive shell.
///
/// This is required because many programs expect fully fledged shell 
/// environment to work propely.
/// Non-interactive shell (so non-`pty`) can provide separated error output.
/// Also the shell will be logged-in with current user, and all current user
/// configurations will be available automatically including program search 
/// paths.
///
/// Collection of utility functions to run `sh` in remote child process.
/// This spawns a new background thread to manage the remote process.
/// The background thread will not finish until the remote process finishes.
///
/// This internally uses `sh` to execute the command. 
/// On OS X, it is likely to be `bash`.
///
/// You can use a shell command `exec` to run a desired command to be executed by
/// replacing the shell process itself.
///
/// Interface is intentionally designed to be similar with `NSTask`.
/// This is just a thin wrapper around NSTask, and does not try to abstract 
/// anything.
///
public class ShellTaskExecutionController {
	public init() {
		_remoteTask.terminationHandler	=	{ [weak self] _ in
			assert(self != nil)
			self!.terminationHandler?()
		}
		_remoteTask.standardInput	=	_stdinPipe
		_remoteTask.standardOutput	=	_stdoutPipe
		_remoteTask.standardError	=	_stderrPipe
	}
	deinit {
		precondition(_remoteTask.running == false, "You must quit the remote process before this object deinitialises.")
	}

	///

	public var standardInput: NSFileHandle {
		get {
			return	_stdinPipe.fileHandleForWriting
		}
	}
	public var standardOutput: NSFileHandle {
		get {
			return	_stdoutPipe.fileHandleForReading
		}
	}
	public var standardError: NSFileHandle {
		get {
			return	_stderrPipe.fileHandleForReading
		}
	}

	///

	public var terminationHandler: (()->())?
	public var terminationStatus: Int32 {
		get {
			return	_remoteTask.terminationStatus
		}
	}
	public var terminationReason: NSTaskTerminationReason {
		get {
			return	_remoteTask.terminationReason
		}
	}

	///
	
	public func launch(workingDirectoryPath workingDirectoryPath: String) {
		assert(try! NSURL(fileURLWithPath: workingDirectoryPath).isExistingAsDirectoryFile())
		
		_remoteTask.currentDirectoryPath	=	workingDirectoryPath
		_remoteTask.launchPath			=	"/bin/bash"			//	TODO:	Need to use `sh` for regularity. But `sh` doesn't work for `cargo`, so temporarily fallback to `bash`.
		_remoteTask.arguments			=	["--login", "-s"]
		
		_remoteTask.launch()
	}
	public func waitUntilExit() {
		_remoteTask.waitUntilExit()
		assert(_remoteTask.running == false)
	}

	/// Sends `SIGTERM` to notify remote process to quit as soon as possible.
	public func terminate() {
		_remoteTask.terminate()
	}
	
	/// Sends `SIGKILL` to forces remote process to quit immediately.
	/// Remote process will be killed by kernel and cannot perform any cleanup.
	public func kill() {
		Darwin.kill(_remoteTask.processIdentifier, SIGKILL)
	}
	
	////
	
	private let	_remoteTask	=	NSTask()
	
	private let	_stdinPipe	=	NSPipe()
	private let	_stdoutPipe	=	NSPipe()
	private let	_stderrPipe	=	NSPipe()

}










