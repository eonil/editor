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

public protocol CargoExecutionControllerDelegate: class {
	func cargoExecutionControllerDidDiscoverRustCompilationIssue(issue:RustCompilerIssue)
}

public class CargoExecutionController {
	weak var delegate:CargoExecutionControllerDelegate?
	
	///	`workingDirectoryURL` must be parent directory of new project directory.
	public class func create(workingDirectoryURL:NSURL, name:String) -> CargoExecutionResult {
		return	execute(workingDirectoryURL, ["new", "-v", name])
	}
	public class func build(workingDirectoryURL:NSURL) -> CargoExecutionResult {
		return	execute(workingDirectoryURL, ["build", "-v"])
	}
	public class func run(workingDirectoryURL:NSURL) -> CargoExecutionResult {
		return	execute(workingDirectoryURL, ["run", "-v"])
	}
	public class func clean(workingDirectoryURL:NSURL) -> CargoExecutionResult {
		return	execute(workingDirectoryURL, ["clean", "-v"])
	}
	
	///	Returns output string.
	public class func execute(workingDirectoryURL:NSURL, _ arguments:[String]) -> CargoExecutionResult {
		assert(workingDirectoryURL.existingAsDirectoryFile)
		
		let	p1	=	workingDirectoryURL.path!
		let	as1	=	join(" ", arguments)
		let	t1	=	NSTask()
		
		t1.currentDirectoryPath	=	p1
		t1.launchPath			=	"/bin/bash"
		t1.arguments			=	["--login", "-s"]
		
		let	in1				=	NSPipe()
		let	out1			=	NSPipe()
		let	err1			=	NSPipe()
		t1.standardInput	=	in1
		t1.standardError	=	err1
		t1.standardOutput	=	out1
		
		t1.launch()
		in1.fileHandleForWriting.writeUTF8String("cargo \(as1)\n")
		in1.fileHandleForWriting.writeUTF8String("exit 0;\n")
		t1.waitUntilExit()
		
		assert(t1.running == false)
		println(t1)
		println("exit code = \(t1.terminationStatus)")
		println("exit reason = \(t1.terminationReason)")
		assert(t1.terminationStatus == 0)
		
		let	out3	=	out1.fileHandleForReading.readUTF8StringToEndOfFile()
		let	err3	=	err1.fileHandleForReading.readUTF8StringToEndOfFile()
		
		Debug.log(out3 + "\n" + err3)
		return	CargoExecutionResult(output: out3, error: err3)
	}
	
	
	
	public enum Command: String {
		case Build	=	"build"
		case New	=	"new"
		case Clean	=	"clean"
		case Run	=	"run"
	}
	
	public init(workingDirectoryURL:NSURL) {
		_linegen	=	LineDispatcher()
		_taskexec	=	ShellTaskExecutionController()
		
		_linegen.onLine	=	{ [weak self] (line:String)->() in
			println(line)
		}
		
		_taskexec.delegate	=	self
		_taskexec.launch(workingDirectoryURL: workingDirectoryURL)
	}
	
	public func launch(command:Command, parameters:[String]) {
		let	as1	=	join(" ", parameters)
		
		_taskexec.writeToStandardInput("cargo \(command.rawValue) \(as1)\n")
		_taskexec.writeToStandardInput("exit $?;\n")
	}
	public func kill() {
		_taskexec.kill()
	}
	
	////
	
	private var	_linegen	:	LineDispatcher
	private let	_taskexec	:	ShellTaskExecutionController
}

extension CargoExecutionController: ShellTaskExecutionControllerDelegate {
	public func shellTaskExecutableControllerDidReadFromStandardOutput(s: String) {
		_linegen.push(s)
	}
	public func shellTaskExecutableControllerDidReadFromStandardError(s: String) {
		_linegen.push(s)
	}
	public func shellTaskExecutableControllerDidTerminateRemoteTask(#exitCode: Int32, reason: NSTaskTerminationReason) {
//		_linegen.push("\n")
	}
}






