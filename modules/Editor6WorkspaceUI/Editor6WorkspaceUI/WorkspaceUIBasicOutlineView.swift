//
//  WorkspaceUIBasicOutlineView.swift
//  Editor6WorkspaceUI
//
//  Created by Hoon H. on 2016/10/17.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import ManualView
import Editor6Common

public final class WorkspaceUIBasicOutlineView: ManualView, NSOutlineViewDataSource, NSOutlineViewDelegate {
    private typealias NodeID = WorkspaceUIBasicOutlineNodeID
    private typealias NodeState = WorkspaceUIBasicOutlineNodeState
    private let scroll = NSScrollView()
    private let outline = NSOutlineView()
    private var localState = WorkspaceUIBasicOutlineState()
    private var idMapping = [NodeID: MappedID]()

    public func reload(_ newState: WorkspaceUIBasicOutlineState) {
        localState = newState
        remapAllIDs()
        outline.reloadData()
    }
    private func remapAllIDs() {
        var newIDMapping = [NodeID: MappedID]()
        for (k, _) in localState.tree {
            newIDMapping[k] = idMapping[k] ?? MappedID(sourceID: k)
        }
        idMapping = newIDMapping
    }

    public override func manual_installSubviews() {
        super.manual_installSubviews()
        addSubview(scroll)
        scroll.documentView = outline
        let col = NSTableColumn()
        outline.addTableColumn(col)
        outline.outlineTableColumn = col
        outline.rowSizeStyle = .small
        outline.allowsMultipleSelection = true

        remapAllIDs()
        outline.dataSource = self
        outline.delegate = self
    }
    public override func manual_layoutSubviews() {
        super.manual_layoutSubviews()
        scroll.frame = bounds
    }

    private func getSourceID(from item: Any) -> NodeID {
        guard let mappedID = item as? MappedID else { fatalError("Unexpected item in `NSOutlineView`.") }
        let id = mappedID.sourceID
        return id
    }

    @objc
    @available(*,unavailable)
    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        func getRootNodeCount() -> Int {
            return localState.showsRootNode ? 1 : localState.tree.children(of: localState.tree.root.id).count
        }
        guard let item = item else { return getRootNodeCount() }
        let id = getSourceID(from: item)
        return localState.tree.children(of: id).count
    }
    @objc
    @available(*,unavailable)
    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let id = getSourceID(from: item)
        return localState.tree[id].isExpandable
    }
    //    @objc
    //    @available(*,unavailable)
    //    public func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
    //        let id = getSourceID(from: item)
    //        return localState.tree[id].isExpandable
    //    }
    @objc
    @available(*,unavailable)
    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        func getRootNodeIDs() -> [NodeID] {
            return localState.showsRootNode
                ? [localState.tree.root.id]
                : localState.tree.children(of: localState.tree.root.id)
        }
        func getChildrenIDs() -> [NodeID] {
            guard let item = item else { return getRootNodeIDs() }
            let id = getSourceID(from: item)
            return localState.tree.children(of: id)
        }
        let childID = getChildrenIDs()[index]
        guard let mappedChildID = idMapping[childID] else { fatalError("Cannot find mapped-ID from child ID `\(childID)`.") }
        return mappedChildID
    }
    //    @objc
    //    @available(*,unavailable)
    //    public func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
    //        guard let mappedID = item as? MappedID else { return false }
    //        let id = mappedID.sourceID
    //        return localState.tree[id]
    //    }
    @objc
    @available(*,unavailable)
    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let id = getSourceID(from: item)
        let state = localState.tree[id]
        let REUSE_ID = NSStringFromClass(CellView.self)
        let cellView = outlineView.make(withIdentifier: REUSE_ID, owner: self) as? CellView ?? CellView()
        cellView.identifier = REUSE_ID
        cellView.reload(state)
        return cellView
    }
}

fileprivate final class CellView: NSTableCellView {
    private let icon = NSImageView()
    private let label = NSTextField()
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        init2()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        init2()
    }
    private func init2() {
        addSubview(icon)
        addSubview(label)
        imageView = icon
        textField = label
        label.isBordered = false
        label.isBezeled = false
        label.drawsBackground = false
        label.isEditable = false
    }

    func reload(_ newState: WorkspaceUIBasicOutlineNodeState) {
        icon.image = newState.icon
        label.stringValue = newState.label ?? ""
    }

    @objc
    @available(*,unavailable)
    override func layout() {
        super.layout()
    }
}

private final class MappedID: NSObject {
    var sourceID: WorkspaceUIBasicOutlineNodeID
    init(sourceID: WorkspaceUIBasicOutlineNodeID) {
        self.sourceID = sourceID
    }
    override var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    @objc
    override var hash: Int {
        return hashValue
    }
    static func == (_ a: MappedID, _ b: MappedID) -> Bool {
        return a === b
    }
}
