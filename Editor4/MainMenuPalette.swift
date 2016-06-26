//
//  MainMenuPalette.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit

struct MainMenuPalette {
    // Keep menu item identifier length < 64.
    let file                            =	submenuContainerWithTitle(.File)
    let fileNew                         =	submenuContainerWithTitle(.FileNew)
    let fileNewWorkspace                =	menuItemWithAction(.FileNewWorkspace)
    let fileNewFolder                   =	menuItemWithAction(.FileNewFolder)
    let fileNewFile                     =	menuItemWithAction(.FileNewFile)
    let fileOpen                        =	submenuContainerWithTitle(.FileOpen)
    let fileOpenWorkspace               =	menuItemWithAction(.FileOpenWorkspace)
    let fileOpenClearWorkspaceHistory	=	menuItemWithAction(.FileOpenClearWorkspaceHistory)
    let fileCloseFile                   =	menuItemWithAction(.FileCloseFile)
    let fileCloseWorkspace              =	menuItemWithAction(.FileCloseWorkspace)
    let fileDelete                      =	menuItemWithAction(.FileDelete)
    let fileShowInFinder                =	menuItemWithAction(.FileShowInFinder)
    let fileShowInTerminal              =	menuItemWithAction(.FileShowInTerminal)

    let view                            =	submenuContainerWithTitle(.View)
    let viewEditor                      =	menuItemWithAction(.ViewEditor)
    let viewNavigators                  =	submenuContainerWithTitle(.ViewShowNavigator)
    let viewShowProjectNavigator        =	menuItemWithAction(.ViewShowProjectNavigator)
    let viewShowIssueNavigator          =	menuItemWithAction(.ViewShowIssueNavigator)
    let viewShowDebugNavigator          =	menuItemWithAction(.ViewShowDebugNavigator)
    let viewHideNavigator               =	menuItemWithAction(.ViewHideNavigator)
    let viewConsole                     =	menuItemWithAction(.ViewConsole)
    let viewFullScreen                  =	menuItemWithAction(.ViewFullScreen)

    let editor                          =	submenuContainerWithTitle(.Editor)
    let editorShowCompletions           =	menuItemWithAction(.EditorShowCompletions)

    let product                         =	submenuContainerWithTitle(.Product)
    let productRun                      =	menuItemWithAction(.ProductRun)
    let productBuild                    =	menuItemWithAction(.ProductBuild)
    let productClean                    =	menuItemWithAction(.ProductClean)
    let productStop                     =	menuItemWithAction(.ProductStop)

    let debug                           =	submenuContainerWithTitle(.Debug)
    let debugPause                      =	menuItemWithAction(.DebugPause)
    let debugResume                     =	menuItemWithAction(.DebugResume)
    let debugHalt                       =	menuItemWithAction(.DebugHalt)

    let debugStepInto                   =	menuItemWithAction(.DebugStepInto)
    let debugStepOut                    =	menuItemWithAction(.DebugStepOut)
    let debugStepOver                   =	menuItemWithAction(.DebugStepOver)

    let debugClearConsole               =	menuItemWithAction(.DebugClearConsole)

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
    func topLevelMenuItemControllers() -> [MenuItemController] {
        return [file, view, editor, product, debug]
    }
}





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private func separator() -> MenuItemController {
    return MenuItemController(type: .Separator)
}
private func submenuContainerWithTitle(mainMenuSubmenuID: MainMenuSubmenuID) -> MenuItemController {
    let submenuID = MenuSubmenuID.Main(mainMenuSubmenuID)
    return MenuItemController(type: .Submenu(submenuID))
}
private func menuItemWithAction(mainMenuCommand: MainMenuCommand) -> MenuItemController {
    let command = MenuCommand.main(mainMenuCommand)
    return MenuItemController(type: .MenuItem(command))
}
































