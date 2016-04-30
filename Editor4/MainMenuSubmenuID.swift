//
//  MainMenuSubmenuID.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/01.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

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