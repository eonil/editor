//
//  MainMenuKeyMappingUtility.swift
//  Editor
//
//  Created by Hoon H. on 2016/11/03.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

enum MainMenuKeyMappingUtility {
    static func makeDefaultKeyMapping() -> MainMenu2State.KeyEquivalentMappings {
        // Creates default mappings.
        var m = MainMenu2State.KeyEquivalentMappings()
        m[.appQuit]             =   .command + "q"
        m[.fileNewWorkspace]    =   .command + .shift + "n"
//        m[.fileOpen]            =   .command + "o"
//        m[.fileSave]            =   .command + "s"
//        m[.fileCloseRepo]       =   .command + "w"
//        m[.productRun]          =   .command + "r"
//        m[.productStop]         =   .command + "."
//        m[.productBuild]        =   .command + "b"
//        m[.productClean]        =   .command + .shift + "k"
        return m
    }
}

private let command = NSEventModifierFlags.command
private let shift   = NSEventModifierFlags.shift
private let option  = NSEventModifierFlags.option
private let control = NSEventModifierFlags.control

private func + (_ a: NSEventModifierFlags, _ b: NSEventModifierFlags) -> NSEventModifierFlags {
    return NSEventModifierFlags([a, b])
}
private func + (_ a: NSEventModifierFlags, _ b: Character) -> MainMenu2State.KeyEquivalentCombination {
    return (a, b)
}
