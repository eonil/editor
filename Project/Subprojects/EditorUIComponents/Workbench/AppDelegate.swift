//
//  AppDelegate.swift
//  Workbench
//
//  Created by Hoon H. on 2015/02/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EditorUIComponents

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!

	let	vc	=	MultipaneViewController()
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		let	v1	=	makeColorView(NSColor.redColor())
		let	v2	=	makeColorView(NSColor.blueColor())
		v1.translatesAutoresizingMaskIntoConstraints	=	false
		v2.translatesAutoresizingMaskIntoConstraints	=	false
		let	vc1	=	NSViewController()
		let	vc2	=	NSViewController()
		vc1.view	=	v1
		vc2.view	=	v2
		let	ps	=	[
			MultipaneViewController.Page(labelText: "Pane 1", viewController: vc1),
			MultipaneViewController.Page(labelText: "Pane 2", viewController: vc2),
		]
		vc.pages	=	ps
		
		////
		
		self.window.contentViewController	=	vc
		self.window.setFrame(CGRect(x: 100, y: 100, width: 200, height: 200), display: true)
		self.window.orderFront(self)
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}


func makeColorView(c:NSColor) -> NSView {
	let	v	=	NSView()
	v.wantsLayer	=	true
	v.layer!.backgroundColor	=	c.CGColor
	return	v
}
