//
//  AppDelegate.swift
//  WorkbenchApp
//
//  Created by Hoon H. on 2015/01/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EditorIssueListingFeature




@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let	vc	=	IssueListingViewController()
		let	sv	=	NSScrollView()
		
		sv.hasHorizontalScroller	=	true
		sv.hasVerticalRuler			=	true
		
		window.contentView	=	sv
		sv.documentView		=	vc.view
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

