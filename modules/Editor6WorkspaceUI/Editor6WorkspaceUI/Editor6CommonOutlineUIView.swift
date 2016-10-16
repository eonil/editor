//
//  Editor6CommonOutlineController.swift
//  Editor6WorkspaceUI
//
//  Created by Hoon H. on 2016/10/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox
import ManualView
import Editor6Common

public struct Editor6CommonOutlineUIState {
    public typealias Node = Editor6CommonOutlineUINode
    /// Allows multiple trees.
    public var tree = Tree<Node>(state: Node())
    public var showsRootNode = true
    public var showsNodeIcons = true
    public var showsNodeLabels = true
    public init() {}
}

public struct Editor6CommonOutlineUINode {
    public var isExpandable = true
//    public var isExpanded = false
    public var icon = NSImage?.none
    public var label = String?.none
    public init() {}
}

public final class Editor6CommonOutlineUIView: ManualView, NSOutlineViewDataSource, NSOutlineViewDelegate {
    private let scroll = NSScrollView()
    private let outline = NSOutlineView()
    private var localState = Editor6CommonOutlineUIState()
    private var idMapping = [TreeNodeKey: MappedID]()

    public func reload(_ newState: Editor6CommonOutlineUIState) {
        localState = newState
        remapAllIDs()
        outline.reloadData()
    }
    private func remapAllIDs() {
        var newIDMapping = [TreeNodeKey: MappedID]()
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

    private func getSourceID(from item: Any) -> TreeNodeKey {
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
        func getRootNodeIDs() -> [TreeNodeKey] {
            return localState.showsRootNode
                ? [localState.tree.root.id]
                : localState.tree.children(of: localState.tree.root.id)
        }
        func getChildrenIDs() -> [TreeNodeKey] {
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

    func reload(_ newState: Editor6CommonOutlineUINode) {
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
    var sourceID: TreeNodeKey
    init(sourceID: TreeNodeKey) {
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
