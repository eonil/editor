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
        // This is required and very important transaction dispatch.
        // Otherwise, driver will not be activated.
        dispatch(Transaction.Reset)
        let id = WorkspaceID()
        let u = NSURL(string: "~/Temp/ws1")!
        dispatch(Transaction.Workspace(id, WorkspaceTransaction.Open))
        dispatch(Transaction.Workspace(id, WorkspaceTransaction.SetCurrent))
        dispatch(Transaction.Workspace(id, WorkspaceTransaction.Reconfigure(location: u)))
        dispatch(Transaction.Workspace(id, WorkspaceTransaction.File(FileTransaction.Select([FileNodePath([])]))))
        dispatch(Command.MainMenu(MainMenuCommand.FileNewWorkspace))
//        dispatch(Transaction.Menu(MainMenuTransaction.FileNewFile))
//        dispatch(Transaction.Menu(MainMenuTransaction.FileNewFolder))
//        dispatch(Transaction.Workspace(id: id, transaction: WorkspaceTransaction.File(FileTransaction.CreateFile(containerFilePath: FileNodePath([]), index: 0, name: "file1"))))
//        dispatch(Transaction.Workspace(id: id, transaction: WorkspaceTransaction.File(FileTransaction.CreateFolder(containerFilePath: FileNodePath([]), index: 0, name: "folder2"))))
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }

    func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
        return false
    }
}

