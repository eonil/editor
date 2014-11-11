//
//  AppDelegate.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/10/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

//	let	main	=	MainController()

	func applicationDidFinishLaunching(aNotification: NSNotification) {
//		main.loadWindow()
//		main.windowDidLoad()
//		main.window!.orderFront(self)
		
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}



	
	
	
	
	
	
}





//
//class MainController : NSWindowController {
//	let	splitter	=	MainSplit()
//	
//	override func loadWindow() {
//		super.window			=	NSWindow()
//		self.window!.styleMask	|=	NSResizableWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask 
//	}
//	override func windowDidLoad() {
//		super.windowDidLoad()
//		self.contentViewController	=	splitter
//	}
//}
//
//class MainSplit : NSSplitViewController {
//	let	codeEditingViewController		=	CodeEditingViewController()
//	let	commandConsoleViewController	=	CommandConsoleViewController()
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		
//		self.splitView.vertical	=	false
//		
//		self.addChildViewController(codeEditingViewController)
//		self.addChildViewController(commandConsoleViewController)
//		self.addSplitViewItem(NSSplitViewItem(viewController: codeEditingViewController))
//		self.addSplitViewItem(NSSplitViewItem(viewController: commandConsoleViewController))
//		
//		self.view.addConstraint(NSLayoutConstraint(item: codeEditingViewController.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 200))
//		self.view.addConstraint(NSLayoutConstraint(item: commandConsoleViewController.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: 200))
//	}
//	override func viewDidAppear() {
//		super.viewDidAppear()
//		
//	}
//}
//
//
//class CodeEditingViewController : TextScrollViewController {
//}
//
//class CommandConsoleViewController : TextScrollViewController {
//	override func viewDidAppear() {
//		super.viewDidAppear()
//	}
//	
//}
//
//
//
//
