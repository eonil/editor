//
//  ShellTaskExecutionController.swift
//  Precompilation
//
//  Created by Hoon H. on 2015/01/17.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation




public protocol ShellTaskExecutionControllerDelegate: class {
	func shellTaskExecutableControllerDidReadFromStandardOutput(String)
	func shellTaskExecutableControllerDidReadFromStandardError(String)
	func shellTaskExecutableControllerRemoteProcessDidTerminate(#exitCode:Int32, reason:NSTaskTerminationReason)
}


///	Runs a non-interactive shell.
///	Non-interactive shell (so non-`pty`) can provide seaprated error output.
///
///	Collection of utility functions to run `sh` in remote child process.
///	This spawns a new background thread to manage the remote process.
///	The background thread will not finish until the remote process finishes.
///
///	Any execution request will return an `Shell.ExecutionController` to control the
///	background thread. You can control the execution using this object. You have to
///	keep this even you don't want to control it, because killing this object will
///	send `SIGNKILL` to the remote process if the process is not finished yet.
///
///	This internally uses `sh` to execute the command. 
///	On OS X, it is likely to be `bash`.
///
///	You can use a shell command `exec` to run a desired command to be executed by
///	replacing the shell process itself.
///
public class ShellTaskExecutionController {
	public weak var delegate:ShellTaskExecutionControllerDelegate?
	
	public init() {
		_remoteTask.standardInput		=	_stdinPipe
		_remoteTask.standardOutput		=	_stdoutPipe
		_remoteTask.standardError		=	_stderrPipe
		
		_stdoutPipe.fileHandleForReading.readabilityHandler	=	{ [weak self](f:NSFileHandle!)->() in
			self?._stdoutReader.push(f.availableData)
			()
		}
		_stderrPipe.fileHandleForReading.readabilityHandler	=	{ [weak self](f:NSFileHandle!)->() in
			self?._stderrReader.push(f.availableData)
			()
		}
		
		_stdoutReader.onString	=	{ [weak self] s in
			self?.delegate?.shellTaskExecutableControllerDidReadFromStandardOutput(s)
			()
		}
		_stderrReader.onString	=	{ [weak self] s in
			self?.delegate?.shellTaskExecutableControllerDidReadFromStandardError(s)
			()
		}
		
		_remoteTask.terminationHandler	=	{ [weak self] t in
			self?.delegate?.shellTaskExecutableControllerRemoteProcessDidTerminate(exitCode: t.terminationStatus, reason: t.terminationReason)
			()
		}
	}
	deinit {
		precondition(_remoteTask.running == false, "You must quit the remote process before this object deinitialises.")
	}
	
	public var	exitCode:Int32 {
		get {
			return	_remoteTask.terminationStatus
		}
	}
	public var exitReason:NSTaskTerminationReason {
		get {
			return	_remoteTask.terminationReason
		}
	}
	
	
	public func launch(#workingDirectoryURL:NSURL) {
		assert(workingDirectoryURL.existingAsDirectoryFile)
		
		let	p1	=	workingDirectoryURL.path!
		
		_remoteTask.currentDirectoryPath	=	p1
		_remoteTask.launchPath			=	"/bin/bash"			//	TODO:	Need to use `sh` for regularity. But `sh` doesn't work for `cargo`, so temporarily fallback to `bash`.
		_remoteTask.arguments			=	["--login", "-s"]
		
		_remoteTask.launch()
	}
	public func writeToStandardInput(s:String) {
		_stdinPipe.fileHandleForWriting.writeUTF8String(s)
	}
	public func waitUntilExit() -> Int32 {
		_remoteTask.waitUntilExit()
		assert(_remoteTask.running == false)
		return	_remoteTask.terminationStatus
	}
	
	///	Sends `SIGTERM` to notify remote process to quit as soon as possible.
	public func terminate() {
		_remoteTask.terminate()
	}
	
	///	Sends `SIGKILL` to forces remote process to quit immediately.
	///	Remote process will be killed by kernel and cannot perform any cleanup.
	public func kill() {
		Darwin.kill(_remoteTask.processIdentifier, SIGKILL)
	}
	
	////
	
	private let	_remoteTask	=	NSTask()
	
	private let	_stdinPipe	=	NSPipe()
	private let	_stdoutPipe	=	NSPipe()
	private let	_stderrPipe	=	NSPipe()
	
	private var	_stdoutReader	=	UTF8StringDispatcher()
	private var	_stderrReader	=	UTF8StringDispatcher()
}











