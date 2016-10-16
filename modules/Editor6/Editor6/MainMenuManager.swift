//
//  MainMenuManager.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import Editor6Common

final class MainMenuManager {
    var dispatch: ((MainMenuAction) -> ())?
    private var localState = MainMenuState()

    /// Set this to `NSApplication.mainMenu` property
    /// to use this menu.
    /// Do not modify this menu yourself. This menu is fully
    /// managed by this manager
    let menu = NSMenu()

    /// Accepts driver state to reconfigure main menu.
    func reload(_ newState: MainMenuState) {
        localState = newState
        updateAllKeyEquivalents(in: menu)
    }
    private func updateAllKeyEquivalents(in m: NSMenu) {
        for mm in menu.items {
            if let mm1 = mm as? MainMenuActionItem {
                mm1.keyEquivalentModifierMask = []
                mm1.keyEquivalent = ""
                guard let action = mm1.actionToDispatch else { continue }
                guard let comb = localState.keyEquivalentMappings[action] else { continue }
                mm1.keyEquivalent = comb.keyEquivelent
                mm1.keyEquivalentModifierMask = comb.keyEquivalentModifierMask
            }
            if let mmm = mm.submenu {
                updateAllKeyEquivalents(in: mmm)
            }
        }
    }
}

private struct MainMenuPalette {
    let file                =   makeGroupItem("File")
    let fileNew             =   makeGroupItem("New")
    let fileNewWorkspace    =   makeActionItem(.fileNewWorkspace, "Workspace...")
    let fileClose           =   makeActionItem(.fileNewWorkspace, "Close")
    let product             =   makeGroupItem("Product")
    let productRun          =   makeActionItem(.productRun, "Run")
    let productStop         =   makeActionItem(.productStop, "Stop")
    let productBuild        =   makeActionItem(.productBuild, "Build")
    let productClean        =   makeActionItem(.productClean, "Clean")
    let debug               =   makeGroupItem("Debug")
    let debugStepOver       =   makeActionItem(.debugStepOver, "Step Over")
    let debugStepInto       =   makeActionItem(.debugStepInto, "Step Into")
    let debugStepOut        =   makeActionItem(.debugStepOut, "Step Out")
}

private func makeGroupItem(_ title: String) -> NSMenuItem {
    let m = NSMenuItem()
    m.title = title
    m.submenu = NSMenu()
    return m
}
private func makeActionItem(_ action: MainMenuAction, _ title: String) -> MainMenuActionItem {
    let m = MainMenuActionItem()
    m.title = title
    m.actionToDispatch = action
    return m
}







