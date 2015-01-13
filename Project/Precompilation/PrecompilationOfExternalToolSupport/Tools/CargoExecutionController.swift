//
//  CargoExecutionController.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import Precompilation

public struct CargoExecutionController {
	
	///	`workingDirectoryURL` must be parent directory of new project directory.
	public static func create(workingDirectoryURL:NSURL, name:String) -> String {
		return	execute(workingDirectoryURL, ["new", name])
	}
	public static func build(workingDirectoryURL:NSURL) -> String {
		return	execute(workingDirectoryURL, ["build"])
	}
	
	///	Returns output string.
	public static func execute(workingDirectoryURL:NSURL, _ arguments:[String]) -> String {
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
		println(t1.terminationStatus)
		println(t1.terminationReason)
		assert(t1.terminationStatus == 0)
		
		let	out3	=	out1.fileHandleForReading.readUTF8StringToEndOfFile()
		let	err3	=	err1.fileHandleForReading.readUTF8StringToEndOfFile()
		let	all		=	out3 + "\n" + err3
		println(all)
		return	all
	}
	
	

}

