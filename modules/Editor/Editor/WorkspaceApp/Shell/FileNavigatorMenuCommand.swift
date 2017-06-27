//
//  FileNavigatorMenuCommand.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/27.
//  Copyright © 2017 Eonil. All rights reserved.
//

enum FileNavigatorMenuCommand {
    case newFolder
    case newFolderWithSelection
    case newFile
    case showInFinder
    case delete
}
extension FileNavigatorMenuCommand {
    var title: String {
        switch self {
        case .newFolder:                return "New Folder"
        case .newFolderWithSelection:   return "New Folder with Selection"
        case .newFile:                  return "New File"
        case .showInFinder:             return "Show in Finder"
        case .delete:                   return "Delete"
        }
    }
}



