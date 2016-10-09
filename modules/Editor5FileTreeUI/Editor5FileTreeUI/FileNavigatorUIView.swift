//
//  FileNavigatorUIView.swift
//  Editor5FileTreeUI
//
//  Created by Hoon H. on 2016/10/08.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import BTree
import EonilToolbox
import Editor5Common

public final class FileNavigatorUIView: Editor5CommonView, NSOutlineViewDataSource, NSOutlineViewDelegate {
    public var dispatch: ((FileNavigatorUIAction) -> ())?

    private let scroll = NSScrollView()
    private let outline = NSOutlineView()
    private let nameColumn = NSTableColumn()

    private var localCopy = FileNavigatorUIState()
    private var idMapping = [FileNavigatorUINodeID: MappedID]()
    private var installer = ViewInstaller()

    // MARK: -
    
    private func render() {
        addSubview(scroll)
        installer.installIfNeeded {
            scroll.documentView = outline
            outline.addTableColumn(nameColumn)
            outline.outlineTableColumn = nameColumn
            outline.rowSizeStyle = .small
            outline.dataSource = self
            outline.delegate = self
        }
        scroll.frame = bounds
    }
    private func remapAllIDs() {
        var newMap = [FileNavigatorUINodeID: MappedID]()
        for (k, _) in localCopy.tree {
            newMap[k] = idMapping[k] ?? MappedID(sourceID: k)
        }
        idMapping = newMap
    }

    // MARK: -

    /// This can be very expensive.
    public func selectedItemIDs() -> Set<FileNavigatorUINodeID> {
        func rowIndexToItemID(rowIndex: Int) -> FileNavigatorUINodeID? {
            assert(outline.item(atRow: rowIndex) is FileNavigatorUINodeID)
            guard let id = outline.item(atRow: rowIndex) as? FileNavigatorUINodeID else { return nil }
            return id
        }
        return Set(outline.selectedRowIndexes.flatMap(rowIndexToItemID))
    }
    public func reload(state newState: FileNavigatorUIState) {
        localCopy = newState
        remapAllIDs()
        outline.reloadData()
    }
    public func addChildItems(_ newChildState: FileNavigatorUINodeState, at index: Int, in parentID: FileNavigatorUINodeID) throws -> FileNavigatorUINodeID {
        guard let children = localCopy.tree.linkages[parentID]?.children else { throw FileNavigatorUIViewError.badID }
        guard children.count > index else { throw FileNavigatorUIViewError.badIndex }
        let id = localCopy.tree.insert(newChildState, at: index, in: parentID)
        remapAllIDs()
        outline.insertItems(at: IndexSet(integer: index), inParent: parentID, withAnimation: [])
        return id
    }
    public func removeChildItem(at index: Int, in parentID: FileNavigatorUINodeID) throws {
        guard let children = localCopy.tree.linkages[parentID]?.children else { throw FileNavigatorUIViewError.badID }
        guard children.count > index else { throw FileNavigatorUIViewError.badIndex }
        localCopy.tree.remove(at: index, in: parentID)
        remapAllIDs()
        outline.removeItems(at: IndexSet(integer: index), inParent: parentID, withAnimation: [])
    }

    // MARK: -

    public override func editor5_layoutSubviews() {
        super.editor5_layoutSubviews()
        render()
    }

    // MARK: -

    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        switch item {
        case nil:
            return 1
        default:
            guard let mappedID = item as? MappedID else { return 0 }
            let id = mappedID.sourceID
            guard let linkage = localCopy.tree.linkages[id] else { return 0 }
            return linkage.children.count
        }
    }
    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let mappedParentID = item as? MappedID? else { return errorMappedID }
        if let parentID = mappedParentID?.sourceID {
            guard let id = localCopy.tree.linkages[parentID]?.children[index] else { return errorMappedID }
            guard let mappedID = idMapping[id] else { return errorMappedID }
            return mappedID
        }
        else {
            guard let mappedID = idMapping[localCopy.tree.root.id] else { return errorMappedID }
            return mappedID
        }
    }
    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let mappedID = item as? MappedID else { return false }
        let id = mappedID.sourceID
        return localCopy.tree[id].type == .folder
    }
    public func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        guard let mappedID = item as? MappedID else { return false }
        let id = mappedID.sourceID
        return localCopy.tree[id]
    }
    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let mappedID = item as? MappedID else { return nil }
        let id = mappedID.sourceID
        let state = localCopy.tree[id]

        let cell = FileNavigatorUINodeCell()
        cell.reload(state)
        return cell
    }
}

final class MappedID: NSObject {
    var sourceID: FileNavigatorUINodeID
    init(sourceID: FileNavigatorUINodeID) {
        self.sourceID = sourceID
    }
}

private let errorMappedID = NSObject()
