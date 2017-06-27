//
//  Tree2.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import EonilToolbox

public protocol Tree2Protocol {
    associatedtype Key
    associatedtype Value
    associatedtype IndexPath
    var count: Int { get }
    ///
    /// - Parameter indexPath:
    ///     Location of target node.
    ///     Use `.root` to access root node.
    ///
    subscript(_ indexPath: IndexPath) -> (Key, Value)? { get set }
    ///
    /// - Returns:
    ///     `nil` if the key does not exist in this tree.
    ///     Keys of children otherwise.
    ///
    func children(of parent: Key) -> [Key]?
}

///
/// Single-rooted one-way stable tree.
///
/// Single-rooted means this tree can have only one root node.
///
/// One-way means tree is designed to traverse from root to leaf only.
/// So walking root to leaf is easy, reverse is very hard. You'd
/// be better to keep separated mapping index if you have to.
///
/// Time Complexity
/// ---------------
/// Operation costs by index-path.
///
/// - Select: amortized O(d) = O(dictionary select) * O(d)
/// - Insert: amortized O(n) = O(dictionary insert) + O(array insert)
/// - Update: amortized O(d) = O(d) + O(dictionary update) + O(dictionary update)
/// - Delete: amortized O(n) = (O(dictoinary delete) * n) + O(array delete)
/// 
/// where
///
/// - d is depth of target node.
/// - n is number of descendants.
///
/// Operations using keys can introduce a few of extra dictionary-select 
/// cost, but should be neglictable.
///
/// Designed as a core assembly for another tree data structure.
///
/// - Note:
///     This type does not provide "index-of" function by design
///     because there's no way to implement it efficiently without 
///     extra data. (requires twice space or O(n^2) time)
///     You are supposed to implement it yourself by
///     defining `Key` type wisely. See `ProjectFeature.FileTree` type
///     for example.
///
public struct Tree2<Key, Value>: Tree2Protocol where Key: Hashable {
    fileprivate var nodes = [NodeID: NodeState]()
    fileprivate var rootID: NodeID?

    public init() {}
    public var isEmpty: Bool {
        return nodes.isEmpty
    }
    public var count: Int {
        return nodes.count
    }
    public var keys: AnyCollection<Key> {
        return AnyCollection(nodes.keys)
    }
    public subscript(_ indexPath: IndexPath) -> (Key, Value)? {
        get {
            return select(at: indexPath)
        }
        set {
            if let newValue = newValue {
                if select(at: indexPath) == nil {
                    insert(newValue.0, newValue.1, at: indexPath)
                }
                else {
                    update(newValue.0, newValue.1, at: indexPath)
                }
            }
            else {
                delete(at: indexPath)
            }
        }
    }
    public subscript(_ key: Key) -> Value? {
        return nodes[key]?.content
    }
    public func children(of parent: Key) -> [Key]? {
        return nodes[parent]?.childNodeIDs
    }

    private func getNode(at indexPath: IndexPath) -> Node? {
        guard nodes.count > 0 else { return nil }
        if indexPath == .root {
            guard let rootID = rootID else { return nil }
            let nodeState = nodes[rootID] >>> AUDIT_unwrapConsistentState
            return (rootID, nodeState)
        }
        else {
            let (parentIndexPath, lastComponent) = indexPath.splitLastComponent()
            let parentNode = getNode(at: parentIndexPath) >>> AUDIT_unwrapConsistentState
            let (_, siblingNodeIDs) = parentNode.state
            guard siblingNodeIDs.count > lastComponent else { return nil }
            let nodeID = siblingNodeIDs[lastComponent]
            let nodeState = nodes[nodeID] >>> AUDIT_unwrapConsistentState
            return (nodeID, nodeState)
        }
    }
    private func select(at indexPath: IndexPath) -> (Key, Value)? {
        guard let (nodeID, nodeState) = getNode(at: indexPath) else { return nil }
        let nodeValue = nodeState.content
        return (nodeID, nodeValue)
    }
    private mutating func insert(_ key: Key, _ value: Value, at indexPath: IndexPath) {
        AUDIT_check(nodes[key] == nil, "You cannot insert an existing key.")
        if indexPath == .root {
            rootID = key
            nodes[key] = (value, [])
        }
        else {
            let (parentIndexPath, lastComponent) = indexPath.splitLastComponent()
            let (parentNodeID, parentNodeState) = AUDIT_unwrapConsistentState(getNode(at: parentIndexPath))
            nodes[key] = (value, [])
            var parentNodeState1 = parentNodeState
            parentNodeState1.childNodeIDs.insert(key, at: lastComponent)
            nodes[parentNodeID] = parentNodeState1
        }
    }
    private mutating func update(_ key: Key, _ value: Value, at indexPath: IndexPath) {
        let (id, state) = AUDIT_unwrapConsistentState(getNode(at: indexPath))
        AUDIT_check(id == key, "Supplied key doesn't match key at the path.")
        AUDIT_check(nodes[id] != nil, "State for key obtained by index-path is missing.")
        let state1 = (value, state.childNodeIDs)
        nodes[id] = state1
    }
    ///
    /// This also deletes all subnodes recursively.
    ///
    private mutating func delete(at indexPath: IndexPath) {
        guard indexPath != .root else { return deleteAll() }
        let node = AUDIT_unwrapConsistentState(getNode(at: indexPath))
        let id = node.id
        do {
            func impl(_ id: NodeID) {
                AUDIT_check(nodes[id] != nil, "You cannot delete an unknown key.")
                let state = AUDIT_unwrapConsistentState(nodes[id])
                for childNodeID in state.childNodeIDs {
                    impl(childNodeID)
                }
                nodes[id] = nil
            }
            impl(id)
        }

        guard indexPath != .root else { return }
        let (parentIndexPath, lastComponent) = indexPath.splitLastComponent()
        var parentNode = AUDIT_unwrapConsistentState(getNode(at: parentIndexPath))
        parentNode.state.childNodeIDs.remove(at: lastComponent)
        nodes[parentNode.id] = parentNode.state
    }
    private mutating func deleteAll() {
        self = Tree2()
    }
}
public extension Tree2 {
    ///
    /// Designate location of a node in tree.
    ///
    /// This defines hierarchical indices to navigate into target
    /// node from the root node. No indices means no navigation, 
    /// so it's the root node. `[1]` means first child of the root
    /// node.
    ///
    public struct IndexPath: Equatable {
        public var components = [Int]()
        public init(components newComponents: [Int]) {
            components = newComponents
        }
        public func appendingLastComponent(_ component: Int) -> IndexPath {
            return IndexPath(components: components + [component])
        }
        public func deletingLastComponent() -> IndexPath {
            return IndexPath(components: Array(components.dropLast()))
        }
        public func splitLastComponent() -> (IndexPath, lastComponent: Int) {
            let (a, b) = components.splitLast()
            return (IndexPath(components: Array(a)), b)
        }
        ///
        /// Equivalent with `IndexPath(components: [])`.
        ///
        public static var root: IndexPath {
            return IndexPath(components: [])
        }
        public static func == (_ a: IndexPath, _ b: IndexPath) -> Bool {
            return a.components == b.components
        }
    }
}
fileprivate extension Tree2 {
    typealias Node = (id: NodeID, state: NodeState)
    typealias NodeID = Key
    typealias NodeState = (content: Value, childNodeIDs: [NodeID])
}

private func AUDIT_unwrapConsistentState<T>(_ v: T?) -> T {
    return AUDIT_unwrap(v, "Inconsistent tree state.")
}

//extension Tree2 where Value: Equatable {
//    ///
//    /// This performs semantic equality comparison.
//    ///
//    public static func == (_ a: Tree2, _ b: Tree2) -> Bool {
//        func f1() -> Bool {
//            return (a.rootID == b.rootID)
//        }
//        func f2() -> Bool {
//            return (Set(a.nodes.keys) == Set(b.nodes.keys))
//        }
//        func f3() -> Bool {
//            for k in a.nodes.keys {
//                let v1 = a.nodes[k]!
//                let v2 = b.nodes[k]!
//                guard v1 == v2 else { return false }
//            }
//            return true
//        }
//        return f1() && f2() && f3()
//    }
//}
//
//private func == <K,V> (_ a: Tree2<K,V>.NodeState, _ b: Tree2<K,V>.NodeState) -> Bool where K: Hashable, V: Equatable {
//    return a.content == b.content && a.childNodeIDs == b.childNodeIDs
//}
