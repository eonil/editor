//
//  AppDelegate.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Cocoa

//@NSApplicationMain
class ApplicationController: NSObject, NSApplicationDelegate, DriverAccessible {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
//        dispatch(Action.Shell(ShellAction.Quit))
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
        return false
    }
}

