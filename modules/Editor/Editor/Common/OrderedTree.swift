////
////  OrderedTree.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/28.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//struct OrderedTree<T> {
//    private var pathToNode = [IndexPath: T]()
//    private var pathToChildCount = [IndexPath: Int]()
//
//    subscript(_ path: IndexPath) -> T {
//        get {
//            return pathToNode[path]!
//        }
//        set(newNode) {
//            precondition(pathToNode[path] != nil)
//            updateImpl(at: path, newNode)
//        }
//    }
//    func numberOfChildren(at path: IndexPath) -> Int? {
//        return pathToChildCount[path]
//    }
//    func at(_ idxp: IndexPath) -> T? {
//        return pathToNode[idxp]
//    }
//    mutating func insert(at path: IndexPath, _ newNode: T) {
//    }
//    mutating func remove(at path: IndexPath) {
//    }
//    private mutating func updateImpl(at: IndexPath, _ newNode: T) {
//    }
//}
//extension OrderedTree {
//    ///
//    /// Designate location of a node in tree.
//    ///
//    /// This defines hierarchical indices to navigate into target
//    /// node from the root node. No indices means no navigation,
//    /// so it's the root node. `[1]` means first child of the root
//    /// node.
//    ///
//    public struct IndexPath: Hashable {
//        public var components = [Int]()
//        public init(components newComponents: [Int]) {
//            components = newComponents
//        }
//        public func hasPrefix(_ idxp: IndexPath) -> Bool {
//            guard idxp.components.count <= components.count else { return false }
//            let range = 0..<idxp.components.count
//            return range
//                .map({ components[$0] == idxp.components[$0] })
//                .reduce(true) { $0 && $1 }
//        }
//        public func appendingLastComponent(_ component: Int) -> IndexPath {
//            return IndexPath(components: components + [component])
//        }
//        public func deletingLastComponent() -> IndexPath {
//            return IndexPath(components: Array(components.dropLast()))
//        }
//        public func splitLastComponent() -> (IndexPath, lastComponent: Int) {
//            let (a, b) = components.splitLast()
//            return (IndexPath(components: Array(a)), b)
//        }
//        ///
//        /// Equivalent with `IndexPath(components: [])`.
//        ///
//        public static var root: IndexPath {
//            return IndexPath(components: [])
//        }
//        public var hashValue: Int {
//            return components.count + (components.last ?? 0)
//        }
//        public static func == (_ a: IndexPath, _ b: IndexPath) -> Bool {
//            return a.components == b.components
//        }
//    }
//}
