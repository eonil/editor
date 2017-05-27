//
//  FileNavigatorUIAction.swift
//  Editor6FileTreeUI
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

public enum FileNavigatorUIAction {
    case clickMenu(FileNavigatorUIMenuItemID)
    case node(FileNavigatorUINodeID, FileNavigatorUINodeAction)
}

public enum FileNavigatorUINodeAction {
    case newFolder
    case newFile
    case rename
    case delete
}
