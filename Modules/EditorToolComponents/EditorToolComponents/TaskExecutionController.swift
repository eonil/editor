////
////  TaskExecutionController.swift
////  Precompilation
////
////  Created by Hoon H. on 2015/01/19.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
//
//
//public protocol TaskExecutionControllerDelegate: class {
//	func taskExecutableControllerDidReadFromStandardOutput(data:NSData)
//	func taskExecutableControllerDidReadFromStandardError(data:NSData)
//	func taskExecutableControllerRemoteProcessDidTerminate(#exitCode:Int32, reason:NSTaskTerminationReason)
//}
//
//
//public class TaskExecutionController {
//	public weak var delegate:TaskExecutionControllerDelegate?
//	
//	public init() {
//		_remoteTask.standardInput		=	_stdinPipe
//		_remoteTask.standardOutput		=	_stdoutPipe
//		_remoteTask.standardError		=	_stderrPipe
//		
//		_stdoutPipe.fileHandleForReading.readabilityHandler	=	{ [weak self](f:NSFileHandle!)->() in
//			self?.delegate?.taskExecutableControllerDidReadFromStandardOutput(f.availableData)
//			()
//		}
//		_stderrPipe.fileHandleForReading.readabilityHandler	=	{ [weak self](f:NSFileHandle!)->() in
//			self?.delegate?.taskExecutableControllerDidReadFromStandardError(f.availableData)
//			()
//		}
//		
//		_remoteTask.terminationHandler	=	{ [weak self] t in
//			self?.delegate?.taskExecutableControllerRemoteProcessDidTerminate(exitCode: t.terminationStatus, reason: t.terminationReason)
//			()
//		}
//	}
//	deinit {
//		precondition(_remoteTask.running == false, "You must quit the remote process before this object deinitialises.")
//	}
//	
//	public var	exitCode:Int32 {
//		get {
//			return	_remoteTask.terminationStatus
//		}
//	}
//	public var exitReason:NSTaskTerminationReason {
//		get {
//			return	_remoteTask.terminationReason
//		}
//	}
//	
//	
//	public func launch(#workingDirectoryURL:NSURL, launchPath:String, arguments:[String]) {
//		assert(workingDirectoryURL.existingAsDirectoryFile)
//		
//		let	p1	=	workingDirectoryURL.path!
//		
//		_remoteTask.currentDirectoryPath	=	p1
//		_remoteTask.launchPath				=	launchPath
//		_remoteTask.arguments				=	arguments
//		
//		_remoteTask.launch()
//	}
//	public func writeToStandardInput(s:String) {
//		_stdinPipe.fileHandleForWriting.writeUTF8String(s)
//	}
//	public func waitUntilExit() -> Int32 {
//		_remoteTask.waitUntilExit()
//		assert(_remoteTask.running == false)
//		return	_remoteTask.terminationStatus
//	}
//	
//	///	Sends `SIGTERM` to notify remote process to quit as soon as possible.
//	public func terminate() {
//		_remoteTask.terminate()
//	}
//	
//	///	Sends `SIGKILL` to forces remote process to quit immediately.
//	///	Remote process will be killed by kernel and cannot perform any cleanup.
//	public func kill() {
//		Darwin.kill(_remoteTask.processIdentifier, SIGKILL)
//	}
//	
//	////
//	
//	private let	_remoteTask	=	NSTask()
//	
//	private let	_stdinPipe	=	NSPipe()
//	private let	_stdoutPipe	=	NSPipe()
//	private let	_stderrPipe	=	NSPipe()
//}
//
//
//
//
//
//
//
//
//
//
//
