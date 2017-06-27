//
//  FileNavigatorMenuCommand.extension.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/27.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

extension FileNavigatorMenuCommand {
    static func makeMenu() -> CommandMenu<FileNavigatorMenuCommand> {
        typealias CMI = CommandMenuItem<FileNavigatorMenuCommand>
        let m = CommandMenu<FileNavigatorMenuCommand>()
        m.autoenablesItems = false
        m.setItems([
            CMI(command: .newFolder,                title: "New Folder"),
            CMI(command: .newFolderWithSelection,   title: "New Folder with Selection"),
            CMI(command: .newFile,                  title: "New File"),
            .separator(),
            CMI(command: .showInFinder,             title: "Show in Finder"),
            .separator(),
            CMI(command: .delete,                   title: "Delete")
            ])
        return m
    }
}

//case newFolder
//case newFolderWithSelection
//case newFile
//case showInFinder
//case delete
