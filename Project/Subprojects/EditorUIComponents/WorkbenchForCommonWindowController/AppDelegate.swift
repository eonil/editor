//
//  AppDelegate.swift
//  WorkbenchForCommonWindowController
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EditorUIComponents

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	let	wc	=	WC1()

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		wc.window!.setFrame(CGRect(x: 0, y: 0, width: 100, height: 100), display: true)
		wc.window!.orderFront(self)
		wc.window!.makeKeyWindow()
	}

	func applicationWillTerminate(aNotification: NSNotification) {
	}


}








class WC1: EditorCommonWindowController3 {
	override func windowDidLoad() {
		super.windowDidLoad()
	}
}