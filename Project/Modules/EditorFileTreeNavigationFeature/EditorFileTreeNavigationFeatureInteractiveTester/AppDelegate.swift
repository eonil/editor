//
//  AppDelegate.swift
//  EditorFileTreeNavigationFeatureInteractiveTester
//
//  Created by Hoon H. on 2015/01/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, FileTreeViewController4Delegate {

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


	func fileTreeViewController4QueryFileSystemSubnodeURLsOfURL(_: NSURL) -> [NSURL] {
		
	}
	func fileTreeViewController4UserWantsToCreateFileInURL(parent: NSURL) -> Resolution<NSURL> {
		return	Resolution
	}
	func fileTreeViewController4UserWantsToCreateFolderInURL(parent: NSURL) -> Resolution<NSURL> {
		
	}
	func fileTreeViewController4UserWantsToDeleteFilesAtURLs(_: [NSURL]) -> Resolution<()> {
		
	}
	func fileTreeViewController4UserWantsToEditFileAtURL(_: NSURL) -> Bool {
		
	}
	func fileTreeViewController4UserWantsToMoveFileAtURL(from: NSURL, to: NSURL) -> Resolution<()> {
		
	}
	func fileTreeViewController4UserWantsToRenameFileAtURL(from: NSURL, to: NSURL) -> Resolution<()> {
		
	}
}

