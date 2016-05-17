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
    let file                            =	submenuContainerWithTitle(.File)
    let fileNew                         =	submenuContainerWithTitle(.FileNew)
    let fileNewWorkspace                =	menuItemWithTransaction(.FileNewWorkspace)
    let fileNewFolder                   =	menuItemWithTransaction(.FileNewFolder)
    let fileNewFile                     =	menuItemWithTransaction(.FileNewFile)
    let fileOpen                        =	submenuContainerWithTitle(.FileOpen)
    let fileOpenWorkspace               =	menuItemWithTransaction(.FileOpenWorkspace)
    let fileOpenClearWorkspaceHistory	=	menuItemWithTransaction(.FileOpenClearWorkspaceHistory)
    let fileCloseFile                   =	menuItemWithTransaction(.FileCloseFile)
    let fileCloseWorkspace              =	menuItemWithTransaction(.FileCloseWorkspace)
    let fileDelete                      =	menuItemWithTransaction(.FileDelete)
    let fileShowInFinder                =	menuItemWithTransaction(.FileShowInFinder)
    let fileShowInTerminal              =	menuItemWithTransaction(.FileShowInTerminal)

    let view                            =	submenuContainerWithTitle(.View)
    let viewEditor                      =	menuItemWithTransaction(.ViewEditor)
    let viewNavigators                  =	submenuContainerWithTitle(.ViewShowNavigator)
    let viewShowProjectNavigator        =	menuItemWithTransaction(.ViewShowProjectNavigator)
    let viewShowIssueNavigator          =	menuItemWithTransaction(.ViewShowIssueNavigator)
    let viewShowDebugNavigator          =	menuItemWithTransaction(.ViewShowDebugNavigator)
    let viewHideNavigator               =	menuItemWithTransaction(.ViewHideNavigator)
    let viewConsole                     =	menuItemWithTransaction(.ViewConsole)
    let viewFullScreen                  =	menuItemWithTransaction(.ViewFullScreen)

    let editor                          =	submenuContainerWithTitle(.Editor)
    let editorShowCompletions           =	menuItemWithTransaction(.EditorShowCompletions)

    let product                         =	submenuContainerWithTitle(.Product)
    let productRun                      =	menuItemWithTransaction(.ProductRun)
    let productBuild                    =	menuItemWithTransaction(.ProductBuild)
    let productClean                    =	menuItemWithTransaction(.ProductClean)
    let productStop                     =	menuItemWithTransaction(.ProductStop)

    let debug                           =	submenuContainerWithTitle(.Debug)
    let debugPause                      =	menuItemWithTransaction(.DebugPause)
    let debugResume                     =	menuItemWithTransaction(.DebugResume)
    let debugHalt                       =	menuItemWithTransaction(.DebugHalt)

    let debugStepInto                   =	menuItemWithTransaction(.DebugStepInto)
    let debugStepOut                    =	menuItemWithTransaction(.DebugStepOut)
    let debugStepOver                   =	menuItemWithTransaction(.DebugStepOver)

    let debugClearConsole               =	menuItemWithTransaction(.DebugClearConsole)

    init() {
        file.subcontrollers = ([
            fileNew,
            fileOpen,
            separator(),
            fileCloseFile,
            fileCloseWorkspace,
            separator(),
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
            separator(),
            viewFullScreen,
            ])
        viewNavigators.subcontrollers = ([
            viewShowProjectNavigator,
            viewShowIssueNavigator,
            viewShowDebugNavigator,
            separator(),
            viewHideNavigator,
            ])

        editor.subcontrollers = ([
            editorShowCompletions,
            ])

        product.subcontrollers = ([
            productRun,
            productBuild,
            productClean,
            separator(),
            productStop,
            ])

        debug.subcontrollers = ([
            debugPause,
            debugResume,
            debugHalt,
            separator(),
            debugStepInto,
            debugStepOut,
            debugStepOver,
            separator(),
            debugClearConsole,
            ])
    }
    func topLevelMenuItemControllers() -> [MainMenuItemController] {
        return [file, view, editor, product, debug]
    }
}





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private func separator() -> MainMenuItemController {
    return MainMenuItemController(type: .Separator)
}
private func submenuContainerWithTitle(id: MainMenuSubmenuID) -> MainMenuItemController {
    return MainMenuItemController(type: .Submenu(id))
}
private func menuItemWithTransaction(command: MainMenuCommand) -> MainMenuItemController {
    return MainMenuItemController(type: .MenuItem(command))
}
































