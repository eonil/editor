//
//  FileNavigatorUISelectionState.swift
//  Editor6FileTreeUI
//
//  Created by Hoon H. on 2016/10/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import Editor6Common

/// - Note:
///     Strictly immutable value. You cannot modify this.
///
public struct FileNavigatorUISelectionState: Sequence {
    private let memosel: MemoizingLazySelection
    public init() {
        self.memosel = MemoizingLazySelection(tree: MemoizingLazySelection.Tree(),
                                              idMapping: [:],
                                              selectionIndices: IndexSet())
    }
    internal init(tree: FileNavigatorUITree, idMapping: [FileNavigatorUINodeID: FileNavigatorUIMappedID], selectionIndices: IndexSet) {
        self.memosel = MemoizingLazySelection(tree: tree,
                                              idMapping: idMapping,
                                              selectionIndices: selectionIndices)
    }
    public var count: Int {
        return memosel.getSelectedNodeIDsWithResolvingIfNeeded().count
    }
    public subscript(_ index: Int) -> FileNavigatorUINodeID {
        get { return memosel.getSelectedNodeIDsWithResolvingIfNeeded()[index] }
    }
    public func makeIterator() -> AnyIterator<FileNavigatorUINodeID> {
        return AnyIterator(memosel.getSelectedNodeIDsWithResolvingIfNeeded().makeIterator())
    }
}

/// - Note: 
///     Ref-type intentioanlly to provide magical break-out from immutable struct.
/// - Note:
///     Thread-unsafe. Read from only main thread.
/// - TODO: Make it resolve incrementally...
///
fileprivate final class MemoizingLazySelection {
    typealias Tree = FileNavigatorUITree
    typealias NodeID = FileNavigatorUINodeID
    typealias MappedID = FileNavigatorUIMappedID

    let tree: Tree
    let idMapping: [NodeID: MappedID]
    var selectionIndices: IndexSet
    var resolutionState = ResolutionState.unresolved

    internal init(tree: Tree, idMapping: [NodeID: MappedID], selectionIndices: IndexSet) {
        self.tree = tree
        self.idMapping = idMapping
        self.selectionIndices = selectionIndices
    }
    fileprivate func getSelectedNodeIDsWithResolvingIfNeeded() -> [NodeID] {
        switch resolutionState {
        case .unresolved:
            do {
                var visibleNodes = [NodeID]()
                collectVisibleNodeIDs(from: tree.root.id, into: &visibleNodes)
                let selectedNodes = selectionIndices.map({ visibleNodes[$0] })
                resolutionState = .resolved(selectedNodes)
                return selectedNodes
            }
        case .resolved(let selectedNodes):
            return selectedNodes
        }
    }
    private func collectVisibleNodeIDs(from: NodeID, into a: inout [NodeID]) {
        a.append(from)
        let state = tree[from]
        if state.isExpanded {
            guard let linkage = tree.linkages[from] else { return }
            for c in linkage.children {
                collectVisibleNodeIDs(from: c, into: &a)
            }
        }
    }
}

private enum ResolutionState {
    case unresolved
    case resolved([FileNavigatorUINodeID])
}
