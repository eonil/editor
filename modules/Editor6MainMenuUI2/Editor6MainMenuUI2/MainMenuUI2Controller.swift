//
//  MainMenuUI2Controller.swift
//  Editor6MainMenuUI2
//
//  Created by Hoon H. on 2016/11/03.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

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
public final class MainMenuUI2Controller {
    private let palette = MainMenuPalette()
    private var delegate: ((MainMenuUI2Action) -> ())?
    private var localState = MainMenuUI2State()

    /// Set this to `NSApplication.mainMenu` property
    /// to use this menu.
    /// Do not modify this menu yourself. This menu is fully
    /// managed by this object.
    public let menu = NSMenu()

    public init() {
        installAllTopMenuItems()
        installAllMenuTargetActionDelegates()
        reload(MainMenuUI2State())
    }
    public func delegate(to newDelegate: @escaping (MainMenuUI2Action) -> ()) {
        delegate = newDelegate
    }
    /// Accepts driver state to reconfigure main menu.
    public func reload(_ newState: MainMenuUI2State) {
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
                guard let m = m as? MainMenuUI2Item else { return }
                guard let id = m.id else { return }
                self?.delegate?(.click(id))
            }
        }
    }
    private func updateAllKeyEquivalents() {
        menu.iterateAllMenuItem { m in
            guard let m = m as? MainMenuUI2Item else { return }
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
            guard let m = m as? MainMenuUI2Item else { return }
            guard let id = m.id else { return }
            m.isEnabled = localState.availableItems.contains(id)
        }
    }
}

/// - Note:
///     DO NOT fear symbolic duplication. It just happens.
///
private struct MainMenuPalette {
    let application         =   makeGroupItem("Application")
    let applicationQuit     =   makeClickableItem(.applicationQuit, "Quit")
    let file                =   makeGroupItem("File")
    let fileNew             =   makeGroupItem("New")
    let fileNewRepo         =   makeClickableItem(.fileNewRepo, "Repository...")
    let fileNewWorkspace    =   makeClickableItem(.fileNewWorkspace, "Workspace")
    let fileOpen            =   makeClickableItem(.fileOpen, "Open...")
    let fileSave            =   makeClickableItem(.fileSave, "Save")
    let fileSaveAs          =   makeClickableItem(.fileSaveAs, "Save As...")
    let fileClose           =   makeClickableItem(.fileClose, "Close")
    let fileCloseRepo       =   makeClickableItem(.fileCloseRepo, "Close Repository")
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
        application.subitems = [
            applicationQuit,
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
            fileCloseRepo,
        ]
        fileNew.subitems = [
            fileNewRepo,
            fileNewWorkspace,
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
            application, file, product, debug,
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
private func makeClickableItem(_ id: MainMenuUI2ItemID, _ title: String) -> MainMenuUI2Item {
    let m = MainMenuUI2Item()
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
