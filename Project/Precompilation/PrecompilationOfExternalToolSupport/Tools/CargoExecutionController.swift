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
	///	Returns output string.
	public static func execute(directoryURL:NSURL) -> String {
		return	run2(directoryURL)
	}
}



private func run2(targetDirectoryURL:NSURL) -> String {
	assert(targetDirectoryURL.existingAsDirectoryFile)
	
	let	p1	=	targetDirectoryURL.path!
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
	in1.fileHandleForWriting.writeUTF8String("cargo build")
	in1.fileHandleForWriting.writeUTF8String("\n")
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


