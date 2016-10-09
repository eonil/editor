//
//  Tree.swift
//  Editor5Common
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import BTree
import EonilToolbox

public struct Tree<Element>: Sequence {
    public typealias TreeNode = (id: TreeNodeKey, state: Element)

    public let root: TreeNode
    internal private(set) var linkages = Map<TreeNodeKey, TreeNodeLinkage>()
    private var states = Map<TreeNodeKey, Element>()

    public init(state: Element) {
        let id = TreeNodeKey()
        self = Tree(root: (id, state))
    }
    public init(root: TreeNode) {
        self.root = root
        self.linkages[root.id] = TreeNodeLinkage()
        self.states[root.id] = root.state
    }

    private func validate() {

    }

    public var count: Int {
        validate()
        return states.count
    }

    public func contains(_ id: TreeNodeKey) -> Bool {
        return states[id] != nil
    }
    private func contains(ids: Set<TreeNodeKey>) -> Bool {
        return ids.map({ states[$0] != nil }).reduce(true, { $0 && $1})
    }
    private func collectAllIDsInSubtree(id: TreeNodeKey) -> Set<TreeNodeKey> {
        guard let linkage = linkages[id] else { fatalError("Bad ID `\(id)`. No node exists for the ID.") }
        var ids = Set<TreeNodeKey>()
        ids.insert(id)
        for id1 in linkage.children {
            ids.formUnion(collectAllIDsInSubtree(id: id1))
        }
        return ids
    }

    public subscript(_ id: TreeNodeKey) -> Element {
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
    public mutating func insert(_ newState: Element, at index: Int, in parentID: TreeNodeKey) -> TreeNodeKey {
        // Read only.
        guard let parentLinkage = linkages[parentID] else { fatalError("Bad parent ID `\(parentID)`. No such node exists") }
        guard parentLinkage.children.count >= index else { fatalError("Bad insertion position index `\(index)`. Out of range.") }
        var newParentLinkage = parentLinkage
        let newChildID = TreeNodeKey()
        newParentLinkage.children.insert(newChildID, at: index)
        // Read/write.
        linkages[parentID] = newParentLinkage
        linkages[newChildID] = TreeNodeLinkage()
        states[newChildID] = newState
        return newChildID
    }

    public mutating func remove(at index: Int, in parentID: TreeNodeKey) {
        // Read only.
        guard let parentLinkage = linkages[parentID] else { fatalError("Bad parent ID `\(parentID)`. No such node exists") }
        guard index < parentLinkage.children.count else { fatalError("Bad removing position index `\(index)`. Out of range.") }
        let deletingChildID = parentLinkage.children[index]
        // Read/write.
        remove([deletingChildID]) // If program crashes here, it's a bug.
    }
    public mutating func remove(_ id: TreeNodeKey) {
        remove([id])
    }
    private mutating func remove(_ ids: Set<TreeNodeKey>) {
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

    public func makeIterator() -> AnyIterator<TreeNode> {
        var it = states.makeIterator()
        return AnyIterator { return it.next() }
    }
}

public struct TreeNodeKey: Hashable, Comparable {
    fileprivate let oid = ObjectAddressID()
    public init() {}
    public var hashValue: Int {
        return oid.hashValue
    }
}
public func == (_ a: TreeNodeKey, _ b: TreeNodeKey) -> Bool {
    return a.oid == b.oid
}
public func < (_ a: TreeNodeKey, _ b: TreeNodeKey) -> Bool {
    return a.oid < b.oid
}

internal struct TreeNodeLinkage {
//    var parent = TreeNodeKey?.none
    internal var children = [TreeNodeKey]()
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
