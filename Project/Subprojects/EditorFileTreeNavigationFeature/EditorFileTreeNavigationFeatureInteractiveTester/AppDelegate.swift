//
//  AppDelegate.swift
//  EditorFileTreeNavigationFeatureInteractiveTester
//
//  Created by Hoon H. on 2015/01/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EditorFileTreeNavigationFeature

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	
	let	scrV	=	NSScrollView()
	let	treeVC	=	FileTreeViewController4()

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		scrV.documentView	=	treeVC.view
		window.contentView	=	scrV
		
		treeVC.URLRepresentation	=	NSURL(fileURLWithPath: "~/Documents/".stringByExpandingTildeInPath, isDirectory: true)
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

