//
//  AppDelegate.swift
//  Test2
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import PseudoTeletypewriter

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	func applicationDidFinishLaunching(aNotification: NSNotification) {
		
		let	pty	=	PseudoTeletypewriter(path: "/bin/ls", arguments: ["/bin/ls", "-Gbla"], environment: ["TERM=ansi"])!
		println(pty.masterFileHandle.readDataToEndOfFile().toString())
		pty.waitUntilChildProcessFinishes()
		
		
//		let	pty	=	PseudoTeletypewriter(path: "/bin/bash", arguments: ["/bin/bash"], environment: ["TERM=ansi"])!
////		pty.masterFileHandle.writeData("ls -Gbla\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
////		println(pty.masterFileHandle.availableData.toString())
//		
//		sleep(1)
//		println(pty.masterFileHandle.availableData.toString())
//		pty.masterFileHandle.writeData("sudo /bin/ls\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)		///	`sudo` also works.
//		
//		sleep(2)
//		println(pty.masterFileHandle.availableData.toString())
//		pty.masterFileHandle.writeData("<type your root password here to test pty>\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
//		
//		sleep(1)
//		println(pty.masterFileHandle.availableData.toString())
//		pty.masterFileHandle.writeData("exit\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
//		
//		println(pty.masterFileHandle.readDataToEndOfFile().toString())
//		pty.waitUntilChildProcessFinishes()
		
		NSApplication.sharedApplication().terminate(self)
		
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}









extension NSData {
	func toUInt8Array() -> [UInt8] {
		let	p	=	self.bytes
		let	p1	=	UnsafePointer<UInt8>(p)
		
		var	bs	=	[] as [UInt8]
		for i in 0..<self.length {
			bs.append(p1[i])
		}
		
		return	bs
	}
	func toString() -> String {
		return	NSString(data: self, encoding: NSUTF8StringEncoding)! as! String
	}
	class func fromUInt8Array(bs:[UInt8]) -> NSData {
		var	r	=	nil as NSData?
		bs.withUnsafeBufferPointer { (p:UnsafeBufferPointer<UInt8>) -> () in
			let	p1	=	UnsafePointer<Void>(p.baseAddress)
			r		=	NSData(bytes: p1, length: p.count)
		}
		return	r!
	}
	
	///	Assumes `cCharacters` is C-string.
	class func fromCCharArray(cCharacters:[CChar]) -> NSData {
		precondition(cCharacters.count == 0 || cCharacters[cCharacters.endIndex.predecessor()] == 0)
		var	r	=	nil as NSData?
		cCharacters.withUnsafeBufferPointer { (p:UnsafeBufferPointer<CChar>) -> () in
			let	p1	=	UnsafePointer<Void>(p.baseAddress)
			r		=	NSData(bytes: p1, length: p.count)
		}
		return	r!
	}
}
