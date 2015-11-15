
//  AppDelegate.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EditorDriver

class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationWillFinishLaunching(notification: NSNotification) {
		// Prevents autogeneration of full-screen menu.
		NSUserDefaults.standardUserDefaults().setBool(false, forKey: "NSFullScreenMenuItemEverywhere")
	}
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		_driver.run()
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		_driver.halt()
	}

	func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
		return	false
	}

	///

	private let	_driver		=	Driver()
}

