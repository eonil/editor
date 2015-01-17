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
public struct CargoExecutionController {
	
	///	`workingDirectoryURL` must be parent directory of new project directory.
	public static func create(workingDirectoryURL:NSURL, name:String) -> CargoExecutionResult {
		return	execute(workingDirectoryURL, ["new", "-v", name])
	}
	public static func build(workingDirectoryURL:NSURL) -> CargoExecutionResult {
		return	execute(workingDirectoryURL, ["build", "-v"])
	}
	public static func run(workingDirectoryURL:NSURL) -> CargoExecutionResult {
		return	execute(workingDirectoryURL, ["run", "-v"])
	}
	public static func clean(workingDirectoryURL:NSURL) -> CargoExecutionResult {
		return	execute(workingDirectoryURL, ["clean", "-v"])
	}
	
	///	Returns output string.
	public static func execute(workingDirectoryURL:NSURL, _ arguments:[String]) -> CargoExecutionResult {
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
	
	

}

