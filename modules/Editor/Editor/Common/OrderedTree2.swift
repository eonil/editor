////
////  OrderedTree2.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/28.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//struct OrderedTree2<T> {
//    private var root: Node?
//    private var cachedCount = 0
//
//    /// O(1)
//    private init(_ r: Node?) {
//        root = r
//    }
//    /// O(depth)
//    private func find(_ path: IndexPath) -> Node? {
//        if path == .root { return root }
//        var n = root!
//        for i in path.components {
//            if i < n.subnodes.count { return nil }
//            n = n.subnodes[i]
//        }
//        return n
//    }
//    private subscript(_ path: IndexPath) -> Node {
//        /// O(depth)
//        get {
//            return find(path)!
//        }
//        /// O(depth)
//        set {
//            let (pp, i) = path.splitLastComponent()
//            var pn = find(pp)!
//            pn.subnodes[i] = newValue
//            self[pp] = pn
//        }
//    }
//
//    /// O(1)
//    init() {
//    }
//
//    /// O(1)
//    var isEmpty: Bool {
//        return cachedCount == 0
//    }
//    /// O(1)
//    var count: Int {
//        return cachedCount
//    }
//    /// O(depth)
//    func contains(at path: IndexPath) -> Bool {
//        let (pp, i) = path.splitLastComponent()
//        guard let pn = find(pp) else { return false }
//        return i < pn.subnodes.count
//    }
//    /// O(depth)
//    func count(at path: IndexPath) -> Int {
//        return self[path].subnodes.count
//    }
//    /// O(1)
//    /// Assumes there's a node at the index.
//    /// (crash if there's no node at the index)
//    func at(_ index: Int) -> T {
//        let p = root!
//        let c = p.subnodes[index]
//        return c.state
//    }
//    /// O(depth)
//    func at(_ path: IndexPath) -> T {
//        return self[path].state
//    }
//    /// O(1)
//    /// Assumes there's a node at the index.
//    /// (crash if there's no node at the index)
//    func subtree(at index: Int) -> OrderedTree2<T> {
//        let p = root!
//        let c = p.subnodes[index]
//        return OrderedTree2(c)
//    }
//    /// O(depth)
//    func subtree(at path: IndexPath) -> OrderedTree2<T> {
//        return OrderedTree2(self[path])
//    }
//    
//    /// Average: O(depth)
//    /// Worst: O(n)
//    mutating func insert(at path: IndexPath, _ element: T) {
//        if path == .root {
//            precondition(root == nil)
//            root = Node(element)
//            return
//        }
//        let (pp, i) = path.splitLastComponent()
//        self[pp].subnodes.insert(Node(element), at: i)
//        cachedCount += 1
//    }
//    /// O(depth)
//    mutating func update(at path: IndexPath, _ element: T) {
//        if path == .root {
//            root = Node(element)
//            return
//        }
//        let (pp, i) = path.splitLastComponent()
//        self[pp].subnodes[i] = Node(element)
//    }
//    /// Average: O(depth)
//    /// Worst: O(n)
//    mutating func remove(at path: IndexPath) {
//        if path == .root {
//            root = nil
//            return
//        }
//        let (pp, i) = path.splitLastComponent()
//        self[pp].subnodes.remove(at: i)
//        cachedCount -= 1
//    }
//}
//private extension OrderedTree2 {
//    /// Copy-on-Write.
//    struct Node {
//        private var impl: NodeImpl
//        init(_ state: T) {
//            impl = NodeImpl(state)
//        }
//        var state: T {
//            get {
//                return impl.state
//            }
//            set {
//                if isKnownUniquelyReferenced(&impl) == false {
//                    impl = impl.clone()
//                }
//                impl.state = newValue
//            }
//        }
//        var subnodes: [Node] {
//            get {
//                return impl.subnodes
//            }
//            set {
//                if isKnownUniquelyReferenced(&impl) == false {
//                    impl = impl.clone()
//                }
//                impl.subnodes = newValue
//            }
//        }
//    }
//    final class NodeImpl {
//        var state: T
//        var subnodes = [Node]()
//        init(_ s: T) {
//            state = s
//        }
//        func clone() -> NodeImpl {
//            let c = NodeImpl(state)
//            c.subnodes = subnodes
//            return c
//        }
//    }
//}
//extension OrderedTree2 {
//    ///
//    /// Designate location of a node in tree.
//    ///
//    /// This defines hierarchical indices to navigate into target
//    /// node from the root node. No indices means no navigation,
//    /// so it's the root node. `[1]` means first child of the root
//    /// node.
//    ///
//    /// This can be optimized further using persistent data structure.
//    /// Now platform provides index-path value-type. Consider using
//    /// that implementation.
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
//        public func splitFirstComponent() -> (firstComponent: Int, IndexPath) {
//            let (a, b) = components.splitFirst()
//            return (a, IndexPath(components: Array(b)))
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
//
