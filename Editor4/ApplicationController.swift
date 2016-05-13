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
        // This is required and very important action dispatch.
        // Otherwise, driver will not be activated.
        dispatch(Action.Reset)
        let id = WorkspaceID()
        let u = NSURL(string: "~/Temp/ws1")!
        dispatch(Action.Workspace(id: id, action: WorkspaceAction.Open))
        dispatch(Action.Workspace(id: id, action: WorkspaceAction.Reconfigure(location: u)))
        dispatch(Action.Workspace(id: id, action: WorkspaceAction.File(FileAction.CreateSubnode(parent: FileNodePath([]), index: 0, state: FileNodeState(name: "file1", comment: nil, isGroup: false)))))
        dispatch(Action.Workspace(id: id, action: WorkspaceAction.File(FileAction.CreateSubnode(parent: FileNodePath([]), index: 1, state: FileNodeState(name: "folder2", comment: nil, isGroup: true)))))
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
        return false
    }
}

