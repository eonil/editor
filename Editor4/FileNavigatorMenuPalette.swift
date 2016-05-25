//
//  FileNavigatorMenuPalette.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit

struct FileNavigatorMenuPalette {
    let context                         =   MenuItemController(type: MenuItemTypeID.Submenu(.FileNavigator(.ContextMenuRoot)))
    let showInFinder                    =   menuItemWithAction(.ShowInFinder)
    let showInTerminal                  =   menuItemWithAction(.ShowInTerminal)
    let createNewFolder                 =   menuItemWithAction(.CreateNewFolder)
    let createNewFile                   =   menuItemWithAction(.CreateNewFile)
    let delete                          =   menuItemWithAction(.Delete)

    init() {
        // Configure hierarchy here if needed.
        context.subcontrollers = [
            showInFinder,
            showInTerminal,
            separator(),
            createNewFolder,
            createNewFile,
            separator(),
            delete,
        ]
    }
}

private func separator() -> MenuItemController {
    return MenuItemController(type: .Separator)
}
//private func submenuContainerWithTitle(mainMenuSubmenuID: MainMenuSubmenuID) -> MenuItemController {
//    let submenuID = FileNavigator(mainMenuSubmenuID)
//    return MenuItemController(type: .Submenu(submenuID))
//}
private func menuItemWithAction(mainMenuCommand: FileNavigatorMenuCommand) -> MenuItemController {
    let command = MenuCommand.FileNavigator(mainMenuCommand)
    return MenuItemController(type: .MenuItem(command))
}
