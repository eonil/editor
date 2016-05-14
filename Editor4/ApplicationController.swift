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
        dispatch(Action.Workspace(id: id, action: WorkspaceAction.SetCurrent))
        dispatch(Action.Workspace(id: id, action: WorkspaceAction.Reconfigure(location: u)))
        dispatch(Action.Workspace(id: id, action: WorkspaceAction.File(FileAction.Select([FileNodePath([])]))))
        dispatch(Action.Menu(MainMenuAction.FileNewFile))
        dispatch(Action.Menu(MainMenuAction.FileNewFolder))
//        dispatch(Action.Workspace(id: id, action: WorkspaceAction.File(FileAction.CreateFile(containerFilePath: FileNodePath([]), index: 0, name: "file1"))))
//        dispatch(Action.Workspace(id: id, action: WorkspaceAction.File(FileAction.CreateFolder(containerFilePath: FileNodePath([]), index: 0, name: "folder2"))))
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
        return false
    }
}

