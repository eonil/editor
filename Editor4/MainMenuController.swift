//
//  MainMenuController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit

final class MainMenuController: DriverAccessible {

    private let palette = MainMenuPalette()

    init() {
        assert(NSApplication.sharedApplication().mainMenu == nil, "Main menu already been set.")

        // `title` really doesn't matter.
        let mainMenu = NSMenu()
        // `title` really doesn't matter.
        let mainAppMenuItem = NSMenuItem(title: "Application", action: nil, keyEquivalent: "")
        mainMenu.addItem(mainAppMenuItem)
        // `title` really doesn't matter.
        mainAppMenuItem.submenu = MainMenuUtility.instantiateApplicaitonMenu()
        for c in palette.topLevelMenuItemControllers() {
            mainMenu.addItem(c.item)
        }

        NSApplication.sharedApplication().mainMenu = mainMenu
    }
    func render() {
        func getCurrentFile() -> (id: FileID2, state: FileState2)? {
            guard let id = driver.state.currentWorkspace?.window.navigatorPane.file.current else { return nil }
            guard let state = driver.state.currentWorkspace?.files[id] else { return nil }
            return (id, state)
        }
        let maybeCurrentFile = getCurrentFile()

        palette.file.enabled = true
        palette.fileNew.enabled = true
        palette.fileNewWorkspace.enabled = true
        palette.fileNewFolder.enabled = (maybeCurrentFile?.state.form == .Container)
        palette.fileNewFile.enabled = (maybeCurrentFile?.state.form == .Container)
        palette.fileOpen.enabled = true
        palette.fileOpenWorkspace.enabled = true
        palette.fileOpenClearWorkspaceHistory.enabled = true
    }
}




















