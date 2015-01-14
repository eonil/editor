//
//  RustProgramExecutionController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/10/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


public class RustProgramExecutionController {
	public init() {
		
	}
	public struct Configuration {
		let	sourceFilePaths:[String]
		let	outputFilePath:String
		let	extraArguments:[String]
		
		public init(sourceFilePaths:[String], outputFilePath:String, extraArguments:[String]) {
			self.sourceFilePaths	=	sourceFilePaths
			self.outputFilePath		=	outputFilePath
			self.extraArguments		=	extraArguments
		}
	}
	
	public func execute(config:Configuration) -> String {
		let	s1	=	join(" ", config.sourceFilePaths.map({"\"" + $0 + "\""}))
		let	s2	=	"-o \"\(config.outputFilePath)\""
		let	ss2	=	join(" ", config.extraArguments)
		return	run2("rustc \(s1) \(s2) \(ss2)")
	}
}






private class RemoteLoggedInBashSession {
}


//private func shell(cmd:String) -> String {
//	let	s2	=	(cmd as NSString).UTF8String
//	system(s2)
//	return	"RUN!"
//}

private func run2(command:String) -> String {
	println(command)
	
	let	t1	=	NSTask()
	
	t1.launchPath			=	"/bin/bash"
	t1.arguments			=	["--login", "-s"]
	
	let	in1				=	NSPipe()
	let	out1			=	NSPipe()
	let	err1			=	NSPipe()
	t1.standardInput	=	in1
	t1.standardError	=	err1
	t1.standardOutput	=	out1
	
	t1.launch()
	in1.fileHandleForWriting.writeUTF8String(command)
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

//private class ExecutingUsingRemoteProcess {
//	let	task:NSTask
//	var	result:String?
//	init(command:String) {
//		task	=	NSTask.launchedTaskWithLaunchPath("/bin/bash", arguments: [command])
//		task.waitUntilExit()
//		
////		dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
////			
////		})
//	}
//}

private extension NSFileHandle {
	func writeUTF8String(s:String) {
		let	d1	=	s.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
		self.writeData(d1)
	}
	func readUTF8StringToEndOfFile() -> String {
		let	d1	=	self.readDataToEndOfFile()
		let	s1	=	NSString(data: d1, encoding: NSUTF8StringEncoding)!
		return	s1
	}
}

