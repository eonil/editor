//
//  MainMenuController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

final class MainMenuController {

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
    }
}




















