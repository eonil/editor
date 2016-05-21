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
        driver.dispatch(Action.Reset)
        let id = WorkspaceID()
        let u = NSURL(string: "~/Temp/ws1")!
        driver.dispatch(Action.Workspace(id, WorkspaceAction.Open))
        driver.dispatch(Action.Workspace(id, WorkspaceAction.SetCurrent))
        driver.dispatch(Action.Workspace(id, WorkspaceAction.Reconfigure(location: u)))
//        guard let rootID = driver.state.currentWorkspace?.files.rootID else { fatalError() }
//        driver.dispatch(Action.Workspace(id, WorkspaceAction.File(FileAction.SelectAllOf([rootID]))))
//        dispatch(Command.MainMenu(MainMenuCommand.FileNewWorkspace))
//        dispatch(Action.Menu(MainMenuAction.FileNewFile))
//        dispatch(Action.Menu(MainMenuAction.FileNewFolder))
//        dispatch(Action.Workspace(id: id, action: WorkspaceAction.File(FileAction.CreateFile(containerFilePath: FileNodePath([]), index: 0, name: "file1"))))
//        dispatch(Action.Workspace(id: id, action: WorkspaceAction.File(FileAction.CreateFolder(containerFilePath: FileNodePath([]), index: 0, name: "folder2"))))
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
        return false
    }
}

