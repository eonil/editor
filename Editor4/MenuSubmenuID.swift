//
//  MenuSubmenuID.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

enum MenuSubmenuID {
    case Main(MainMenuSubmenuID)
    case FileNavigator(FileNavigatorMenuSubmenuID)
}
extension MenuSubmenuID {
    func getLabel() -> String {
        switch self {
        case .Main(let submenuID):              return submenuID.getLabel()
        case .FileNavigator(let submenuID):     return submenuID.getLabel()
        }
    }
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

enum MainMenuSubmenuID {
    case File
    case FileNew
    case FileOpen
    case View
    case ViewShowNavigator
    case Editor
    case Product
    case Debug
}
extension MainMenuSubmenuID {
    func getLabel() -> String {
        switch self {
        case .File:                             return "File"
        case .FileNew:                          return "New"
        case .FileOpen:                         return "Open"
        case .View:                             return "View"
        case .ViewShowNavigator:                return "Navigators"
        case .Editor:                           return "Editor"
        case .Product:                          return "Product"
        case .Debug:                            return "Debug"
        }
    }
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

enum FileNavigatorMenuSubmenuID {
    case ContextMenuRoot
    func getLabel() -> String {
        switch self {
        case .ContextMenuRoot:                  return "FileNavigatorContextMenu"
        }
    }
}