//
//  MainMenuState.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

struct MainMenuState {
    typealias KeyEquivalentCombination = (keyEquivalentModifierMask: NSEventModifierFlags, keyEquivelent: String)
    typealias KeyEquivalentMappings = [MainMenuAction: KeyEquivalentCombination]
    var keyEquivalentMappings = KeyEquivalentMappings()
    init() {
        // Creates default mappings.
        var m = KeyEquivalentMappings()
        m[.fileNewWorkspace]    =   .command + .shift + "n"
        m[.productRun]          =   .command + "r"
        m[.productStop]         =   .command + "."
        m[.productBuild]        =   .command + "b"
        m[.productClean]        =   .command + .shift + "k"
    }
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

private let command = NSEventModifierFlags.command
private let shift = NSEventModifierFlags.shift
private let option = NSEventModifierFlags.option
private let control = NSEventModifierFlags.control

private func + (_ a: NSEventModifierFlags, _ b: NSEventModifierFlags) -> NSEventModifierFlags {
    return NSEventModifierFlags([a, b])
}
private func + (_ a: NSEventModifierFlags, _ b: String) -> MainMenuState.KeyEquivalentCombination {
    return (a, b)
}
