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

        m[.testdriveMakeRandomFiles]    =   .command + "1"
        m[.testdriveMakeWorkspace]      =   .command + "2"

        m[.appQuit]             =   .command + "q"
        m[.fileNewWorkspace]    =   .command + .shift + "n"
        m[.fileOpen]            =   .command + "o"
        m[.fileSave]            =   .command + "s"
        m[.fileClose]           =   .command + .shift + "w"
        m[.fileCloseWorkspace]  =   .command + "w"
        m[.productRun]          =   .command + "r"
        m[.productStop]         =   .command + "."
        m[.productBuild]        =   .command + "b"
        m[.productClean]        =   .command + .shift + "k"
        return m
    }
}

private func + (_ a: NSEvent.ModifierFlags, _ b: NSEvent.ModifierFlags) -> NSEvent.ModifierFlags {
    return NSEvent.ModifierFlags([a, b])
}
private func + (_ a: NSEvent.ModifierFlags, _ b: Character) -> MainMenu2State.KeyEquivalentCombination {
    return (a, b)
}
