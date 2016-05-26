//
//  MenuCommandShortcutKeys.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit

extension MenuCommand {
    func getShortcutKey() -> MenuItemShortcutKey? {
        switch self {
        case .Main(let command):            return command.getShortcutKey()
        case .FileNavigator(let command):   return command.getShortcutKey()
        }
    }
    func getKeyModifiersAndKeyEquivalentPair() -> (keyModifier: NSEventModifierFlags, keyEquivalent: String) {
        let shortcut = getShortcutKey()
        return (shortcut?.keyModifiers ?? [], shortcut?.keyEquivalent ?? "")
    }
}
private extension MainMenuCommand {
    private func getShortcutKey() -> MenuItemShortcutKey? {
        let Command     =       NSEventModifierFlags.CommandKeyMask
        let Option      =       NSEventModifierFlags.AlternateKeyMask
        let Control     =       NSEventModifierFlags.ControlKeyMask
        let Shift       =       NSEventModifierFlags.ShiftKeyMask
        let Return      =       "\r"
        let Delete      =       "\u{0008}"
        let F6          =       String(UnicodeScalar(NSF6FunctionKey))
        let F7          =       String(UnicodeScalar(NSF7FunctionKey))
        let F8          =       String(UnicodeScalar(NSF8FunctionKey))

        switch self {
        case .FileNewWorkspace:                 return Command + Control + "N"
        case .FileNewFolder:                    return Command + Option + "N"
        case .FileNewFile:                      return Command + "N"
        case .FileOpenWorkspace:                return Command + Control + "O"
        case .FileOpenClearWorkspaceHistory:    return nil
        case .FileCloseFile:                    return Command + Shift + "W"
        case .FileCloseWorkspace:               return Command + "W"
        case .FileDelete:                       return Command + Delete
        case .FileShowInFinder:                 return nil
        case .FileShowInTerminal:               return nil
        case .ViewEditor:                       return Command + Return
        case .ViewShowProjectNavigator:         return Command + "1"
        case .ViewShowIssueNavigator:           return Command + "2"
        case .ViewShowDebugNavigator:           return Command + "3"
        case .ViewHideNavigator:                return Command + "0"
        case .ViewConsole:                      return Command + Shift + "C"
        case .ViewFullScreen:                   return Command + Control + "F"
        case .EditorShowCompletions:            return Command + " "
        case .ProductRun:                       return Command + "R"
        case .ProductBuild:                     return Command + "B"
        case .ProductClean:                     return Command + Shift + "K"
        case .ProductStop:                      return Command + "."
        case .DebugPause:                       return Command + Control + "Y"
        case .DebugResume:                      return Command + Control + "Y"
        case .DebugHalt:                        return nil
        case .DebugStepInto:                    return Command + F6
        case .DebugStepOut:                     return Command + F7
        case .DebugStepOver:                    return Command + F8
        case .DebugClearConsole:                return Command + "K"
        }
    }
}
private extension FileNavigatorMenuCommand {
    private func getShortcutKey() -> MenuItemShortcutKey? {
        return nil
    }
}







////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct MenuItemShortcutKey {
    var keyModifiers: NSEventModifierFlags
    var keyEquivalent: String
}
private func + (a: NSEventModifierFlags, b: NSEventModifierFlags) -> MenuItemShortcutKey {
    return MenuItemShortcutKey(keyModifiers: [a, b], keyEquivalent: "")
}
private func + (a: NSEventModifierFlags, b: String) -> MenuItemShortcutKey {
    return MenuItemShortcutKey(keyModifiers: a, keyEquivalent: b.lowercaseString)
}
private func + (a: MenuItemShortcutKey, b: String) -> MenuItemShortcutKey {
    return MenuItemShortcutKey(keyModifiers: a.keyModifiers, keyEquivalent: a.keyEquivalent + b.lowercaseString)
}
