//
//  AppDelegate.swift
//  Workbench
//
//  Created by Hoon H. on 2015/02/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EditorCommon
import EditorToolComponents



class CargoTest: CargoExecutionControllerDelegate {
	let	exe	=	CargoExecutionController()
	init() {
		exe.delegate	=	self
		
		let	w	=	NSURL(string: "file:///Users/Eonil/Temp/racer")!
		
		exe.launchRun(workingDirectoryURL: w)
	}
	
	func cargoExecutionControllerDidPrintMessage(s: String) {
		println("MSG: \(s)")
	}
	func cargoExecutionControllerDidDiscoverRustCompilationIssue(issue: RustCompilerIssue) {
		println("ISSUE: \(issue)")
	}
	func cargoExecutionControllerRemoteProcessDidTerminate() {
		println("TERM")
	}
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	let	t1	=	CargoTest()
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		
//		UIDialogues.queryDeletingFilesUsingWindowSheet(window, files: [NSURL(string: "AA")!]) { (b:UIDialogueButton) -> () in
//			switch b {
//			case .OKButton:
//				println("OK")
//				
//			case .CancelButton:
//				println("Cancel")
//				
//			}
//		}

		
		
//		let	s	=	String(contentsOfFile: "/Users/Eonil/Workshop/Incubation/Editor/Project/Subprojects/Precompilation/PrecompilationUnitTest/example1.txt", encoding: NSUTF8StringEncoding, error: nil)!
//		let	ss	=	RustCompilerOutputParsing.parseErrorOutput(s)
//
//		for s in ss {
//			println(s)
//		}
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

