//
//  FileNavigatorUIAction.swift
//  Editor5FileTreeUI
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

public enum FileNavigatorUIAction {
    case node(FileNavigatorUINodeID, FileNavigatorUINodeAction)
}

public enum FileNavigatorUINodeAction {
    case newFolder
    case newFile
    case rename
    case delete
}
