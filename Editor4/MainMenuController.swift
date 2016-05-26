//
//  MainMenuController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit

final class MainMenuController: DriverAccessible, Renderable {

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
        func getOptionalFileStateOf(optionalID: FileID2?) -> FileState2? {
            guard let id = optionalID else { return nil }
            return driver.userInteractionState.currentWorkspace?.files[id]
        }
        let optionalWorkspace = driver.userInteractionState.currentWorkspace
        let optionalSelection = optionalWorkspace?.window.navigatorPane.file.selection

        palette.file.enabled                            =   true
        palette.fileNew.enabled                         =   true
        palette.fileNewWorkspace.enabled                =   true
        palette.fileNewFolder.enabled                   =   (getOptionalFileStateOf(optionalSelection?.getHighlightOrCurrent())?.form == .Container)
        palette.fileNewFile.enabled                     =   (getOptionalFileStateOf(optionalSelection?.getHighlightOrCurrent())?.form == .Container)
        palette.fileOpen.enabled                        =   true
        palette.fileOpenWorkspace.enabled               =   true
        palette.fileOpenClearWorkspaceHistory.enabled   =   true
        palette.fileCloseWorkspace.enabled              =   (optionalWorkspace != nil)
        palette.fileDelete.enabled                      =   (optionalSelection?.getHighlightOrItems().isEmpty == false)
        palette.fileShowInFinder.enabled                =   (optionalSelection?.getHighlightOrItems().isEmpty == false)
        palette.fileShowInTerminal.enabled              =   (optionalSelection?.getHighlightOrItems().isEmpty == false)
    }
}




















