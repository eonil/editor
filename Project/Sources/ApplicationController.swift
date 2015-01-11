//
//  ApplicationController.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa

@NSApplicationMain
class ApplicationController: NSObject, NSApplicationDelegate {
}













///	MARK:
///	MARK:	Application Lifecycle Management
extension ApplicationController {
	func applicationDidFinishLaunching(aNotification: NSNotification) {
	}
	
	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
}













///	MARK:
///	MARK:	Document Handling
extension ApplicationController {
	func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
		return	false
	}
}














///	MARK:
///	MARK:	Menu Handlers
extension ApplicationController {
	@objc @IBAction
	func newWorkspaceMenuOnClick(AnyObject?) {
//		var	e	=	nil as NSError?
//		let	d	=	WorkspaceDocument(type: "", error: e)!
		NSDocumentController.sharedDocumentController().newDocument(self)
	}
	
	@objc @IBAction
	func newFileMenuOnClock(AnyObject?) {
		
	}
}











