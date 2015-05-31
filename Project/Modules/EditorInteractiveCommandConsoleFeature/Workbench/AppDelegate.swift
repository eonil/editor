//
//  AppDelegate.swift
//  Workbench
//
//  Created by Hoon H. on 2015/01/17.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EditorInteractiveCommandConsoleFeature

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let	sv	=	NSScrollView()
		window.contentView	=	sv
		
		let	vc	=	ConsoleViewController()
		sv.documentView		=	vc.view
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

