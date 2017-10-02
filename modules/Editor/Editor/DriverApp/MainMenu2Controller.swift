//
//  MainMenu2Controller.swift
//  Editor
//
//  Created by Hoon H. on 2016/11/03.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

///
/// View controller for main menu.
///
/// This is a simple view-controller, and does not
/// perform any particular model stuffs. Just render menu
/// and dispatch action back to delegate.
///
/// Most (not all) main menu items are bound to specific menu actions.
/// Only items you can control and send action have an ID.
///
public final class MainMenu2Controller {
    let event = Relay<Event>()
    private let palette = MainMenuPalette()
    private var localState = MainMenu2State()

    /// Set this to `NSApplication.mainMenu` property
    /// to use this menu.
    /// Do not modify this menu yourself. This menu is fully
    /// managed by this object.
    public let menu = NSMenu()

    public init() {
        installAllTopMenuItems()
        installAllMenuTargetActionDelegates()
        reload(MainMenu2State())
    }

    /// Accepts driver state to reconfigure main menu.
    public func reload(_ newState: MainMenu2State) {
        localState = newState
        updateAllKeyEquivalents()
        updateAllEnabledState()
    }

    private func installAllTopMenuItems() {
        palette.getAllTopMenuItems().forEach { m in
            menu.addItem(m)
        }
    }
    private func installAllMenuTargetActionDelegates() {
        menu.iterateAllMenuItem { m in
            m.delegate { [weak self] in
                guard let ss = self else { return }
                guard let m = m as? MainMenu2Item else { return }
                guard let id = m.id else { return }
                ss.event.cast(.click(id))
            }
        }
    }
    private func updateAllKeyEquivalents() {
        menu.iterateAllMenuItem { m in
            guard let m = m as? MainMenu2Item else { return }
            m.keyEquivalentModifierMask = []
            m.keyEquivalent = ""
            guard let id = m.id else { return }
            guard let comb = localState.keyEquivalentMappings[id] else { return }
            m.keyEquivalent = String(comb.keyEquivelent)
            m.keyEquivalentModifierMask = comb.keyEquivalentModifierMask
        }
    }
    private func updateAllEnabledState() {
        menu.iterateAllMenuItem { m in
            guard let m = m as? MainMenu2Item else { return }
            guard let id = m.id else { return }
            m.isEnabled = localState.availableItems.contains(id)
        }
    }
}
extension MainMenu2Controller {
    enum Event {
        case click(MainMenuItemID)
    }
}

/// - Note:
///     DO NOT fear symbolic duplication. It just happens.
///
private struct MainMenuPalette {
    let testdrive1          =   makeClickableItem(.testdriveMakeRandomFiles, "Make Random Files")
    let testdrive2          =   makeClickableItem(.testdriveMakeWorkspace, "Make Workspace")
    let app                 =   makeGroupItem("Application")
    let appQuit             =   makeClickableItem(.appQuit, "Quit")
    let file                =   makeGroupItem("File")
    let fileNew             =   makeGroupItem("New")
    let fileNewWorkspace    =   makeClickableItem(.fileNewWorkspace, "Workspace...")
    let fileNewFolder       =   makeClickableItem(.fileNewFolder, "Folder")
    let fileNewFile         =   makeClickableItem(.fileNewFile, "File")
    let fileOpen            =   makeClickableItem(.fileOpen, "Open...")
    let fileSave            =   makeClickableItem(.fileSave, "Save")
    let fileSaveAs          =   makeClickableItem(.fileSaveAs, "Save As...")
    let fileClose           =   makeClickableItem(.fileClose, "Close")
    let fileCloseWorkspace  =   makeClickableItem(.fileCloseWorkspace, "Close Workspace")
    let fileRename          =   makeClickableItem(.fileRename, "Rename")
    let product             =   makeGroupItem("Product")
    let productRun          =   makeClickableItem(.productRun, "Run")
    let productStop         =   makeClickableItem(.productStop, "Stop")
    let productBuild        =   makeClickableItem(.productBuild, "Build")
    let productClean        =   makeClickableItem(.productClean, "Clean")
    let debug               =   makeGroupItem("Debug")
    let debugStepOver       =   makeClickableItem(.debugStepOver, "Step Over")
    let debugStepInto       =   makeClickableItem(.debugStepInto, "Step Into")
    let debugStepOut        =   makeClickableItem(.debugStepOut, "Step Out")

    init() {
        app.subitems = [
            testdrive1,
            testdrive2,
            appQuit,
        ]
        file.subitems = [
            fileNew,
            makeSeparatorItem(),
            fileOpen,
            makeSeparatorItem(),
            fileSave,
            fileSaveAs,
            makeSeparatorItem(),
            fileClose,
            fileCloseWorkspace,
            fileRename,
        ]
        fileNew.subitems = [
            fileNewWorkspace,
            fileNewFolder,
            fileNewFile,
        ]
        product.subitems = [
            productRun,
            makeSeparatorItem(),
            productBuild,
            productClean,
            productStop,
        ]
        debug.subitems = [
            debugStepOver,
            debugStepInto,
            debugStepOut,
        ]
    }
    func getAllTopMenuItems() -> [NSMenuItem] {
        return [
            app,
            file, 
            product,
            debug,
        ]
    }
}

private func makeGroupItem(_ title: String) -> NSMenuItem {
    let m = NSMenuItem()
    m.title = title
    let sm = NSMenu(title: title)
    sm.autoenablesItems = false // Very important.
    m.submenu = sm
    return m
}
private func makeClickableItem(_ id: MainMenuItemID, _ title: String) -> MainMenu2Item {
    let m = MainMenu2Item()
    m.title = title
    m.id = id
    return m
}
private func makeSeparatorItem() -> NSMenuItem {
    return NSMenuItem.separator()
}

private extension NSMenu {
    func iterateAllMenuItem(_ f: (NSMenuItem) -> ()) {
        for m in items {
            f(m)
            guard let mm = m.submenu else { continue }
            mm.iterateAllMenuItem(f)
        }
    }
}

private extension NSMenuItem {
    var subitems: [NSMenuItem] {
        get { return submenu?.items ?? [] }
        set {
            assert(submenu != nil)
            submenu?.removeAllItems()
            newValue.forEach { submenu?.addItem($0) }
        }
    }
}
