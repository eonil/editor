//
//  AppDelegate.swift
//  Workbench1
//
//  Created by Hoon H. on 2015/02/22.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EditorWorkspaceNavigationFeature




@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	let	sv	=	NSScrollView()
	let	nv	=	WorkspaceNavigationViewController()

	func applicationDidFinishLaunching(aNotification: NSNotification) {

		sv.documentView		=	nv.view
		window.contentView	=	sv
		
		let	u	=	NSBundle.mainBundle().URLForResource("TestData/Test1", withExtension: "eews")
		nv.URLRepresentation	=	u
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

