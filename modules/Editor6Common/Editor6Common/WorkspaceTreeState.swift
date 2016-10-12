////
////  WorkspaceTreeState.swift
////  Editor6FileTreeUI
////
////  Created by Hoon H. on 2016/10/09.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import EonilToolbox
//import BTree
//
///// ...
/////
///// Mutation is try-and-error. Because checking input validity outside
///// is usually far harder then checking inside. So all mutators checks
///// input validity, and throws an error if it's invalid.
/////
///// All mutators work transactionally.
///// Which means if it throws an error, it does not mutate anything.
/////
//public struct WorkspaceTreeState {
//    public let root: WorkspaceItem
//    public private(set) var items = Map<WorkspaceItemID, WorkspaceItemState>()
//
//    public init() {
//        let id = WorkspaceItemID()
//        let state = WorkspaceItemState(name: "")
//        self = WorkspaceTreeState(root: (id, state))
//    }
//    public init(root: WorkspaceItem) {
//        self.root = root
//        self.items[root.id] = root.state
//    }
//    private func contains(ids: Set<WorkspaceItemID>) -> Bool {
//        return ids.map({ items[$0] != nil }).reduce(true, { $0 && $1})
//    }
//    private func collectAllIDsInSubtree(id: WorkspaceItemID) throws -> Set<WorkspaceItemID> {
//        guard let state = items[id] else { throw WorkspaceTreeStateError.badID }
//        var ids = Set<WorkspaceItemID>()
//        ids.insert(id)
//        for id1 in state.children {
//            ids.formUnion(try collectAllIDsInSubtree(id: id1))
//        }
//        return ids
//    }
//
//    /// Mutates transactionally.
//    public mutating func insertChild(state newChildState: WorkspaceItemState, at index: Int, in parentID: WorkspaceItemID) throws -> WorkspaceItemID {
//        // Read only.
//        guard let parentState = items[parentID] else { throw WorkspaceTreeStateError.badID }
//        guard parentState.children.count >= index else { throw WorkspaceTreeStateError.badIndex }
//        var newParentState = parentState
//        let newChildID = WorkspaceItemID()
//        items[newChildID] = newChildState
//        newParentState.children.insert(newChildID, at: index)
//        // Read/write.
//        items[parentID] = newParentState
//        return newChildID
//    }
//
//    /// Mutates transactionally.
//    public mutating func removeItems(for ids: Set<WorkspaceItemID>) throws {
//        // Read only.
//        var ids1 = ids
//        for id in ids {
//            ids1.formUnion(try collectAllIDsInSubtree(id: id))
//        }
//        // Read/write.
//        for id in ids1 {
//            items[id] = nil
//        }
//    }
//
//    /// Mutates transactionally.
//    public mutating func remove(at index: Int, in parentID: WorkspaceItemID) throws {
//        // Read only.
//        guard let parentState = items[parentID] else { throw WorkspaceTreeStateError.badID }
//        guard index < parentState.children.count else { throw WorkspaceTreeStateError.badIndex }
//        // Read/write.
//        var newParentState = parentState
//        let deletingChildID = parentState.children[index]
//        try! removeItems(for: [deletingChildID]) // If program crashes here, it's a bug.
//        newParentState.children.remove(at: index)
//    }
//}
//
//public typealias WorkspaceItem = (id: WorkspaceItemID, state: WorkspaceItemState)
//public struct WorkspaceItemID: Hashable, Comparable {
//    fileprivate let oid = ObjectAddressID()
//    public init() {
//    }
//    public var hashValue: Int {
//        return oid.hashValue
//    }
//}
//public func == (_ a: WorkspaceItemID, _ b: WorkspaceItemID) -> Bool {
//    return a.oid == b.oid
//}
//public func < (_ a: WorkspaceItemID, _ b: WorkspaceItemID) -> Bool {
//    return a.oid < b.oid
//}
//
//public struct WorkspaceItemState {
//    public var name: String
//    public var type = WorkspaceItemType.folder
//    public fileprivate(set) var children = [WorkspaceItemID]()
//    public init(name: String) {
//        self.name = name
//    }
//}
//
//public enum WorkspaceItemType {
//    case folder
//    case document
//}
//
//public enum WorkspaceTreeStateError: Error {
//    case badID
//    case badIndex
//}
