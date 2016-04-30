//
//  MainMenuPalette.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

struct MainMenuPalette {
    // Keep menu item identifier length < 64.
    let file                            =	MenuItemController(code: .File)
    let fileNew                         =	MenuItemController(code: .FileNew)
    let fileNewWorkspace                =	MenuItemController(code: .FileNewWorkspace)
    let fileNewFolder                   =	MenuItemController(code: .FileNewFolder)
    let fileNewFile                     =	MenuItemController(code: .FileNewFile)
    let fileOpen                        =	MenuItemController(code: .FileOpen)
    let fileOpenWorkspace               =	MenuItemController(code: .FileOpenWorkspace)
    let fileOpenClearWorkspaceHistory	=	MenuItemController(code: .FileOpenClearWorkspaceHistory)
    let fileCloseFile                   =	MenuItemController(code: .FileCloseFile)
    let fileCloseWorkspace              =	MenuItemController(code: .FileCloseWorkspace)
    let fileDelete                      =	MenuItemController(code: .FileDelete)
    let fileShowInFinder                =	MenuItemController(code: .FileShowInFinder)
    let fileShowInTerminal              =	MenuItemController(code: .FileShowInTerminal)

    let view                            =	MenuItemController(code: .View)
    let viewEditor                      =	MenuItemController(code: .ViewEditor)
    let viewNavigators                  =	MenuItemController(code: .ViewShowNavigator)
    let viewShowProjectNavigator        =	MenuItemController(code: .ViewShowProjectNavigator)
    let viewShowIssueNavigator          =	MenuItemController(code: .ViewShowIssueNavigator)
    let viewShowDebugNavigator          =	MenuItemController(code: .ViewShowDebugNavigator)
    let viewHideNavigator               =	MenuItemController(code: .ViewHideNavigator)
    let viewConsole                     =	MenuItemController(code: .ViewConsole)
    let viewFullScreen                  =	MenuItemController(code: .ViewFullScreen)

    let editor                          =	MenuItemController(code: .Editor)
    let editorShowCompletions           =	MenuItemController(code: .EditorShowCompletions)

    let product                         =	MenuItemController(code: .Product)
    let productRun                      =	MenuItemController(code: .ProductRun)
    let productBuild                    =	MenuItemController(code: .ProductBuild)
    let productClean                    =	MenuItemController(code: .ProductClean)
    let productStop                     =	MenuItemController(code: .ProductStop)

    let debug                           =	MenuItemController(code: .Debug)
    let debugPause                      =	MenuItemController(code: .DebugPause)
    let debugResume                     =	MenuItemController(code: .DebugResume)
    let debugHalt                       =	MenuItemController(code: .DebugHalt)

    let debugStepInto                   =	MenuItemController(code: .DebugStepInto)
    let debugStepOut                    =	MenuItemController(code: .DebugStepOut)
    let debugStepOver                   =	MenuItemController(code: .DebugStepOver)

    let debugClearConsole               =	MenuItemController(code: .DebugClearConsole)

    init() {
        file.subcontrollers = ([
            fileNew,
            fileOpen,
            MenuItemController(code: .Separator),
            fileCloseFile,
            fileCloseWorkspace,
            MenuItemController(code: .Separator),
            fileDelete,
            fileShowInFinder,
            fileShowInTerminal,
            ])
        fileNew.subcontrollers = ([
            fileNewWorkspace,
            fileNewFile,
            fileNewFolder,
            ])
        fileOpen.subcontrollers = ([
            fileOpenWorkspace,
            fileOpenClearWorkspaceHistory,
            ])

        view.subcontrollers = ([
            viewEditor,
            viewNavigators,
            viewConsole,
            MenuItemController(code: .Separator),
            viewFullScreen,
            ])
        viewNavigators.subcontrollers = ([
            viewShowProjectNavigator,
            viewShowIssueNavigator,
            viewShowDebugNavigator,
            MenuItemController(code: .Separator),
            viewHideNavigator,
            ])

        editor.subcontrollers = ([
            editorShowCompletions,
            ])

        product.subcontrollers = ([
            productRun,
            productBuild,
            productClean,
            MenuItemController(code: .Separator),
            productStop,
            ])

        debug.subcontrollers = ([
            debugPause,
            debugResume,
            debugHalt,
            MenuItemController(code: .Separator),
            debugStepInto,
            debugStepOut,
            debugStepOver,
            MenuItemController(code: .Separator),
            debugClearConsole,
            ])
    }
    func topLevelMenuItemControllers() -> [MenuItemController] {
        return [file, view, editor, product, debug]
    }
}



