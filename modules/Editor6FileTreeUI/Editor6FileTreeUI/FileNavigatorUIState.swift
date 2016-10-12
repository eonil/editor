//
//  FileNavigatorUITree.swift
//  Editor6FileTreeUI
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import EonilToolbox
import BTree

public struct FileNavigatorUIState {
    public var tree = FileNavigatorUITree()
    public init() {}
}

/// ...
///
/// Mutation is try-and-error. Because checking input validity outside
/// is usually far harder then checking inside. So all mutators checks
/// input validity, and throws an error if it's invalid.
///
/// All mutators work transactionally.
/// Which means if it throws an error, it does not mutate anything.
///
public struct FileNavigatorUITree: Sequence {
    public let root: FileNavigatorUINode
    internal private(set) var linkages = Map<FileNavigatorUINodeID, FileNavigatorUINodeLinkage>()
    private var states = Map<FileNavigatorUINodeID, FileNavigatorUINodeState>()

    public init() {
        let id = FileNavigatorUINodeID()
        let state = FileNavigatorUINodeState()
        self = FileNavigatorUITree(root: (id, state))
    }
    public init(root: FileNavigatorUINode) {
        self.root = root
        self.linkages[root.id] = FileNavigatorUINodeLinkage()
        self.states[root.id] = root.state
    }

    private func validate() {

    }

    public var count: Int {
        validate()
        return states.count
    }

    public func contains(_ id: FileNavigatorUINodeID) -> Bool {
        return states[id] != nil
    }
    private func contains(ids: Set<FileNavigatorUINodeID>) -> Bool {
        return ids.map({ states[$0] != nil }).reduce(true, { $0 && $1})
    }
    private func collectAllIDsInSubtree(id: FileNavigatorUINodeID) -> Set<FileNavigatorUINodeID> {
        guard let linkage = linkages[id] else { fatalError("Bad ID `\(id)`. No node exists for the ID.") }
        var ids = Set<FileNavigatorUINodeID>()
        ids.insert(id)
        for id1 in linkage.children {
            ids.formUnion(try collectAllIDsInSubtree(id: id1))
        }
        return ids
    }

    public subscript(_ id: FileNavigatorUINodeID) -> FileNavigatorUINodeState {
        get {
            return states[id]!
        }
        set {
            precondition(states[id] != nil)
            states[id] = newValue
        }
    }

    /// Inserts a new node at index under parent.
    /// - Parameter index:
    ///     MUST be a proper index to insert a new node in the parent node.
    /// - Parameter parentID:
    ///     MUST be an ID to an existing node.
    /// - Returns:
    ///     ID to newrly inserted node.
    @discardableResult
    public mutating func insert(_ newState: FileNavigatorUINodeState, at index: Int, in parentID: FileNavigatorUINodeID) -> FileNavigatorUINodeID {
        // Read only.
        guard let parentLinkage = linkages[parentID] else { fatalError("Bad parent ID `\(parentID)`. No such node exists") }
        guard parentLinkage.children.count >= index else { fatalError("Bad insertion position index `\(index)`. Out of range.") }
        var newParentLinkage = parentLinkage
        let newChildID = FileNavigatorUINodeID()
        newParentLinkage.children.insert(newChildID, at: index)
        // Read/write.
        linkages[parentID] = newParentLinkage
        linkages[newChildID] = FileNavigatorUINodeLinkage()
        states[newChildID] = newState
        return newChildID
    }
    @discardableResult
    public mutating func insert(at index: Int, in parentID: FileNavigatorUINodeID) -> FileNavigatorUINodeID {
        return insert(FileNavigatorUINodeState(), at: index, in: parentID)
    }

    public mutating func remove(at index: Int, in parentID: FileNavigatorUINodeID) {
        // Read only.
        guard let parentLinkage = linkages[parentID] else { fatalError("Bad parent ID `\(parentID)`. No such node exists") }
        guard index < parentLinkage.children.count else { fatalError("Bad removing position index `\(index)`. Out of range.") }
        let deletingChildID = parentLinkage.children[index]
        // Read/write.
        remove([deletingChildID]) // If program crashes here, it's a bug.
    }
    public mutating func remove(_ id: FileNavigatorUINodeID) {
        remove([id])
    }
    private mutating func remove(_ ids: Set<FileNavigatorUINodeID>) {
        // Read only.
        var ids1 = ids
        for id in ids {
            ids1.formUnion(collectAllIDsInSubtree(id: id))
        }
        // Read/write.
        for id in ids1 {
            linkages[id] = nil
            states[id] = nil
        }
    }


    // MARK: -

    public func makeIterator() -> AnyIterator<FileNavigatorUINode> {
        var it = states.makeIterator()
        return AnyIterator { return it.next() }
    }
}

public typealias FileNavigatorUINode = (id: FileNavigatorUINodeID, state: FileNavigatorUINodeState)
public struct FileNavigatorUINodeID: Hashable, Comparable {
    fileprivate let oid = ObjectAddressID()
    public init() {
    }
    public var hashValue: Int {
        return oid.hashValue
    }
}
public func == (_ a: FileNavigatorUINodeID, _ b: FileNavigatorUINodeID) -> Bool {
    return a.oid == b.oid
}
public func < (_ a: FileNavigatorUINodeID, _ b: FileNavigatorUINodeID) -> Bool {
    return a.oid < b.oid
}

internal struct FileNavigatorUINodeLinkage {
//    var prent = FileNavigatorUINodeID?.none
    internal var children = [FileNavigatorUINodeID]()
}

public struct FileNavigatorUINodeState {
    public var icon = URL?.none
    public var name = String?.none
    public var type = FileNavigatorUINodeType.folder
    public init() {}
}

public enum FileNavigatorUINodeType {
    case folder
    case document
}

public enum FileNavigatorUITreeError: Error {
    case badID
    case badIndex
}

private extension Array {
    func inserted(_ newElement: Element, at index: Int) -> Array {
        var copy = self
        copy.insert(newElement, at: index)
        return copy
    }
    func replaced(_ newElement: Element, at index: Int) -> Array  {
        var copy = self
        copy[index] = newElement
        return copy
    }
    func removed(at index: Int) -> Array {
        var copy = self
        copy.remove(at: index)
        return copy
    }
}
