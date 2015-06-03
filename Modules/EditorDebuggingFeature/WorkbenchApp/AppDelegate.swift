//
//  AppDelegate.swift
//  WorkbenchApp
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


//	let	py	=	PythonLLDBKernelController()
//	let	lldbcon	=	LLDBController()
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let	u	=	NSURL(fileURLWithPath: "~/Temp/".stringByExpandingTildeInPath)!
		
//		py.launch(u)
		
//		lldbcon.launch(u)
//		lldbcon.createDebugger()
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

