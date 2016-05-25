//
//  MenuCommand.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// Every menu commands in the application are
/// represented with this.
enum MenuCommand {
    case Main(MainMenuCommand)
    case FileNavigator(FileNavigatorMenuCommand)
}

/// Main menu command means literally what will be done when a main menu
/// item hs been clicked.
enum MainMenuCommand {
//    case File
//    case FileNew
    case FileNewWorkspace
    case FileNewFolder
    case FileNewFile
//    case FileOpen
    case FileOpenWorkspace
    case FileOpenClearWorkspaceHistory
    case FileCloseFile
    case FileCloseWorkspace
    case FileDelete
    case FileShowInFinder
    case FileShowInTerminal
//    case View
    case ViewEditor
//    case ViewShowNavigator
    case ViewShowProjectNavigator
    case ViewShowIssueNavigator
    case ViewShowDebugNavigator
    case ViewHideNavigator
    case ViewConsole
    case ViewFullScreen
//    case Editor
    case EditorShowCompletions
//    case Product
    case ProductRun
    case ProductBuild
    case ProductClean
    case ProductStop
//    case Debug
    case DebugPause
    case DebugResume
    case DebugHalt
    case DebugStepInto
    case DebugStepOut
    case DebugStepOver
    case DebugClearConsole
}

enum FileNavigatorMenuCommand {
    case ShowInFinder
    case ShowInTerminal
    case CreateNewFolder
    case CreateNewFile
    case Delete
}







