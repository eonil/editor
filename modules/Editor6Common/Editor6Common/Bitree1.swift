//
//  Bitree1.swift
//  Editor6Common
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import BTree
import EonilToolbox

///
/// Bidirectional tree.
///
/// "Bidirectional" means you can navigate between parent-child in freely.
///
public struct Bitree1<TKey, TValue>: Sequence where TKey: Bitree1NodeKey {
    public typealias TState = TValue
    public typealias Bitree1Node = (id: TKey, state: TState)
    typealias TLinkage = Bitree1NodeLinkage<TKey>

    public let root: Bitree1Node
    internal private(set) var linkages = Map<TKey, TLinkage>()
    private var states = Map<TKey, TState>()

    public init(state: TState) {
        let id = TKey()
        self = Bitree1(root: (id, state))
    }
    internal init(root: Bitree1Node) {
        self.root = root
        self.linkages[root.id] = Bitree1NodeLinkage()
        self.states[root.id] = root.state
    }

    private func validate() {
        MARK_unimplemented()
    }

    public var count: Int {
        validate()
        return states.count
    }

    public func contains(_ id: TKey) -> Bool {
        return states[id] != nil
    }
    private func containsAll(ids: Set<TKey>) -> Bool {
        return ids.map({ states[$0] != nil }).reduce(true, { $0 && $1})
    }
    private func collectAllIDsInSubtree(id: TKey) -> Set<TKey> {
        guard let linkage = linkages[id] else { fatalError("Bad ID `\(id)`. No node exists for the ID.") }
        var ids = Set<TKey>()
        ids.insert(id)
        for id1 in linkage.children {
            ids.formUnion(collectAllIDsInSubtree(id: id1))
        }
        return ids
    }

    public subscript(_ id: TKey) -> TState {
        get {
            return states[id]!
        }
        set {
            precondition(states[id] != nil)
            states[id] = newValue
        }
    }
    public func parent(of id: TKey) -> TKey? {
        guard let linkage = linkages[id] else { fatalError("Cannot find node for ID `\(id)`.") }
        return linkage.parent
    }
    public func children(of id: TKey) -> [TKey] {
        guard let linkage = linkages[id] else { fatalError("Cannot find node for ID `\(id)`.") }
        return linkage.children
    }

    ///
    /// Inserts a new node at index under parent.
    ///
    /// - Parameter index:
    ///     MUST be a proper index to insert a new node in the parent node.
    /// - Parameter parentID:
    ///     MUST be an ID to an existing node.
    /// - Returns:
    ///     ID to newrly inserted node.
    ///
    @discardableResult
    public mutating func insert(_ newChildNode: Bitree1Node, at index: Int, in parentID: TKey) -> TKey {
        // Read only.
        precondition(linkages[newChildNode.id] == nil, "Bad new node ID `\(newChildNode.id)`. The key is already exists in this tree.")
        guard let parentLinkage = linkages[parentID] else { fatalError("Bad parent ID `\(parentID)`. No such node exists") }
        guard parentLinkage.children.count >= index else { fatalError("Bad insertion position index `\(index)`. Out of range.") }
        var newParentLinkage = parentLinkage
        newParentLinkage.children.insert(newChildNode.id, at: index)
        // Read/write.
        linkages[parentID] = newParentLinkage
        var newChildLinkage = Bitree1NodeLinkage<TKey>()
        newChildLinkage.parent = parentID
        linkages[newChildNode.id] = newChildLinkage
        states[newChildNode.id] = newChildNode.state
        return newChildNode.id
    }
    @discardableResult
    public mutating func insert(_ newState: TState, at index: Int, in parentID: TKey) -> TKey {
        return insert((TKey(), newState), at: index, in: parentID)
    }

    public mutating func remove(at index: Int, in parentID: TKey) {
        // Read only.
        guard let parentLinkage = linkages[parentID] else { fatalError("Bad parent ID `\(parentID)`. No such node exists") }
        guard index < parentLinkage.children.count else { fatalError("Bad removing position index `\(index)`. Out of range.") }
        let deletingChildID = parentLinkage.children[index]
        // Read/write.
        remove([deletingChildID]) // If program crashes here, it's a bug.
    }
    public mutating func remove(_ id: TKey) {
        remove([id])
    }
    private mutating func remove(_ ids: Set<TKey>) {
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

    public func makeIterator() -> AnyIterator<Bitree1Node> {
        var it = states.makeIterator()
        return AnyIterator { return it.next() }
    }
}

public protocol Bitree1NodeKey: Hashable, Comparable {
    init()
}

internal struct Bitree1NodeLinkage<TKey: Bitree1NodeKey> {
    internal var parent = TKey?.none
    internal var children = [TKey]()
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
