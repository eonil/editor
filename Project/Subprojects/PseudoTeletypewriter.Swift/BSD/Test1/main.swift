//
//  main.swift
//  Test1
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation


//	https://developer.apple.com/library/mac/technotes/tn2050/_index.html







//extension NSTask {
//	var standardInputFileHandle:NSFileHandle {
//		get {
//			return	standardInput as NSFileHandle
//		}
//	}
//	var standardOutputFileHandle:NSFileHandle {
//		get {
//			return	standardOutput as NSFileHandle
//		}
//	}
//	var standardOutputPipe:NSPipe {
//		get {
//			return	standardOutput as NSPipe
//		}
//	}
//}
//extension NSFileHandle {
//	func readUTF8StringToEndOfFile() -> String {
//		let	d	=	readDataToEndOfFile()
//		let	s	=	NSString(data: d, encoding: NSUTF8StringEncoding)!
//		return	s
//	}
////	func writeUTF8String(s:String) {
////		let	d	=	s.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
////		writeData(d)
////	}
//	func writeUInt8Array(bytes:[UInt8]) {
//		bytes.withUnsafeBufferPointer { (p:UnsafeBufferPointer<UInt8>) -> () in
//			let	p1	=	UnsafePointer<Void>(p.baseAddress)
//			let	d	=	NSData(bytes: p1, length: p.count)
//			self.writeData(d)
//		}
//	}
//}


///////////////////













//let	k	=	forkPseudoTeletypewriter()
//let	r	=	k.result
//let	f	=	k.master.toFileHandle(true)
////let	r	=	BSD.fork()
//if r.ok {
//	if r.isRunningInParentProcess {
//		println("parent: ok, child pid = \(r.processID)")
//		println(f.readDataToEndOfFile().toString())
//		
//		waitpid(r.processID, nil, 0)
//		println("parent: child finished")
//	} else {
//		println("child: ok")
////		execute("/usr/bin/printf", arguments: ["/usr/bin/printf", "BBB"], environment: ["TERM=xterm-256color"])
//		execute("/bin/ls", ["/bin/ls", "-Gbla", "."], ["TERM=ansi"])
////		execute("/usr/bin/env", arguments: [], environment: ["TERM=xterm-256color"])
//		println("child: finished")
//	}
//} else {
////	fatalError()
//}


















































//let	ControlZ	=	0x1A as UInt8
//let	ControlC	=	0x03 as UInt8
//let	Escape		=	0x1B as UInt8
//
//let	inPipe		=	NSPipe()
//let	outPipe		=	NSPipe()
//let	errPipe		=	NSPipe()
//let	proc		=	NSTask()
//
//
//
//proc.standardInput	=	inPipe
//proc.standardOutput	=	outPipe
//proc.standardError	=	errPipe
//
////proc.launchPath		=	"/usr/bin/env"
//proc.launchPath		=	"/bin/ls"
//proc.arguments		=	["-G", "/Users/Eonil/"]
//proc.environment	=	[
////					:
////	"TERM"			:	"ansi"
////	"TERM"			:	"xterm"
//	"TERM"			:	"xterm-256color"
//]
//println("START")
//proc.launch()
////stdin.writeUInt8Array([ControlC])
//let	output		=	outPipe.fileHandleForReading.readDataToEndOfFile()
//let	output1		=	output.toUInt8Array()
//let	output2		=	output.toString()
//proc.waitUntilExit()
//println("FINISH")
//
//println(output2)
//println(countElements(output2.utf8))
//println(output1.count)
////println(countElements("A\u{001B}A"))




