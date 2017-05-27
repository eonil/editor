//
//  FileNavgatorUIMenuController.swift
//  Editor6FileTreeUI
//
//  Created by Hoon H. on 2017/03/09.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import AppKit

final class FileNavigatorUIMenuController {
    let menu = NSMenu()
    private let palette = MenuPalette()
    init() {
        palette.makeOrganized().forEach(menu.addItem)
    }
    func apply(_ newState: FileNavigatorUIState) {
        var availableItemIDs = FileNavigatorUIMenuItemID([])
        // TODO: O(n). Optimize for performance...
        for fileID in newState.selection {
            let s = newState.tree[fileID]
            availableItemIDs.formIntersection(s.availableMenuItemIDs)
        }
        for m in menu.items {
            guard let m1 = m as? FileNavigatorUIMenuItem else { continue }
            guard let id = m1.id else { continue }
            m1.isEnabled = availableItemIDs.contains(id)
        }
    }
}

private struct MenuPalette {
    let showInFinder    =   makeClickableItem(.showInFinder, "Show in Finder")
    let newFile         =   makeClickableItem(.newFile, "New File")
    let newFolder       =   makeClickableItem(.newFolder, "New Folder")
    let rename          =   makeClickableItem(.rename, "Rename")
    let groupSelection  =   makeClickableItem(.groupSelection, "New Group from Selection")
    let delete          =   makeClickableItem(.delete, "Delete")
    func makeOrganized() -> [NSMenuItem] {
        return [
            showInFinder,
            makeSeparatorItem(),
            newFile,
            newFolder,
            makeSeparatorItem(),
            rename,
            makeSeparatorItem(),
            groupSelection,
            makeSeparatorItem(),
            delete,
        ]
    }
}

private func makeGroupItem(_ title: String) -> NSMenuItem {
    let m = NSMenuItem()
    m.title = title
    let sm = NSMenu(title: title)
    sm.autoenablesItems = false // Very important.
    m.submenu = sm
    return m
}
private func makeClickableItem(_ id: FileNavigatorUIMenuItemID, _ title: String) -> FileNavigatorUIMenuItem {
    let m = FileNavigatorUIMenuItem()
    m.title = title
    m.id = id
    return m
}
private func makeSeparatorItem() -> NSMenuItem {
    return NSMenuItem.separator()
}


private final class FileNavigatorUIMenuItem: NSMenuItem {
    var id = FileNavigatorUIMenuItemID?.none
}
