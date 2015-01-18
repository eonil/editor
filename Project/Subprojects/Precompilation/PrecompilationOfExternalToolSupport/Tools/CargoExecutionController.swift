//
//  CargoExecutionController.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import Precompilation


public struct CargoExecutionResult {
	public var	output:String
	public var	error:String
	
	public func issues() -> [RustCompilerIssue] {
		return	RustCompilerOutputParsing.parseErrorOutput(error)
	}
}


///	CAUTION
///	-------
///	All methods can be called from non-main thread.
public protocol CargoExecutionControllerDelegate: class {
	func cargoExecutionControllerDidPrintMessage(s:String)
	func cargoExecutionControllerDidDiscoverRustCompilationIssue(issue:RustCompilerIssue)
	func cargoExecutionControllerRemoteProcessDidTerminate()
}







///	Asynchronous `cargo` execution controller.
///
///	This is one-time use only object. You cannot run multiple 
///	commands on single object. You have to create a new object
///	to run another command.
///
///	CAUTION
///	-------
///	Delegate methods can be called from non-main thread.
public class CargoExecutionController {
	public weak var delegate:CargoExecutionControllerDelegate! {
		willSet {
			assert(delegate == nil)		//	Once bound delegate cannot be changed.
		}
	}
	
	public init() {
		_taskexec			=	ShellTaskExecutionController()
		_stdout_linedisp	=	LineDispatcher()
		_stderr_linedisp	=	LineDispatcher()
		
		_stdout_linedisp.onLine	=	{ [weak self] (line:String)->() in
			self?.delegate.cargoExecutionControllerDidPrintMessage(line)
			()
		}
		
		_stderr_linedisp.onLine	=	{ [weak self] (line:String)->() in
			let	ss	=	RustCompilerOutputParsing.parseErrorOutput(line)
			if ss.count > 0 {
				for s in ss {
					self?.delegate.cargoExecutionControllerDidDiscoverRustCompilationIssue(s)
				}
			}
		}
		
		_taskexec.delegate	=	self
	}
	public func launch(#workingDirectoryURL:NSURL, arguments expression:String) {
		_taskexec.launch(workingDirectoryURL: workingDirectoryURL)
		
		_taskexec.writeToStandardInput("cargo \(expression)\n")
		_taskexec.writeToStandardInput("exit $?;\n")
	}
	public func kill() {
		_taskexec.kill()
	}
	public func waitUntilExit() {
		_taskexec.waitUntilExit()
	}
	
	////
	
	private let	_taskexec			:	ShellTaskExecutionController
	private var	_stdout_linedisp	:	LineDispatcher
	private var	_stderr_linedisp	:	LineDispatcher
}

extension CargoExecutionController: ShellTaskExecutionControllerDelegate {
	public func shellTaskExecutableControllerDidReadFromStandardOutput(s: String) {
		_stdout_linedisp.push(s)
	}
	public func shellTaskExecutableControllerDidReadFromStandardError(s: String) {
		_stderr_linedisp.push(s)
	}
	public func shellTaskExecutableControllerRemoteProcessDidTerminate(#exitCode: Int32, reason: NSTaskTerminationReason) {
		_stdout_linedisp.dispatchIncompleteLine()
		_stderr_linedisp.dispatchIncompleteLine()
		self.delegate.cargoExecutionControllerRemoteProcessDidTerminate()
	}
}

extension CargoExecutionController {
	///	`workingDirectoryURL` must be parent directory of new project directory.
	public func launchNew(#workingDirectoryURL:NSURL, desiredWorkspaceName:String) {
		self.launch(workingDirectoryURL: workingDirectoryURL, arguments: "new --verbose \(desiredWorkspaceName)")
	}
	public func launchBuild(#workingDirectoryURL:NSURL) {
		self.launch(workingDirectoryURL: workingDirectoryURL, arguments: "build --verbose")
	}
	public func launchClean(#workingDirectoryURL:NSURL) {
		self.launch(workingDirectoryURL: workingDirectoryURL, arguments: "clean --verbose")
	}
	public func launchRun(#workingDirectoryURL:NSURL) {
		self.launch(workingDirectoryURL: workingDirectoryURL, arguments: "run --verbose")
	}
}






