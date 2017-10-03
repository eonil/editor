////
////  FileTree3.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/28.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
/////
///// New implementation which will replace `Tree2`.
/////
///// IT IS NOT YET BEING USED BECAUSE THERE IS TOO MUCH WORK TO REPLACE.
///// DO THIS LATER.
/////
///// Problems of `Tree2`
///// -------------------
///// - Too complex. It's harder to maintain.
///// - It's complex because it does index-path and file/path/name
/////   operation at once.
/////   Split them into two types.
///// - Semantics are not clean.
///// - No subtree query. This makes getting children harder.
/////
///// Solutions
///// ---------
///// - Split implementation into two layers; (1) index-path, (2) file/path/name.
/////   Index-path operation is done by `OrderedTree2` type.
/////   File/path/name operation is done by `FileTree3`.
///// - Provide subtree query. This is natural interface to get children of
/////   a node. And this is provided in fully value-type semantics.
///// - More likely to be optimized as this adapts persistent data structure.
/////   Because this shares many nodes between versions. Less copying.
/////
//struct FileTree3 {
//    typealias Path = ProjectItemPath
//    typealias Index = OrderedTree2<Node>.IndexPath
//    private var core = OrderedTree2<Node>()
//
//    /// O(1)
//    init() {}
//    /// O(1)
//    private init(_ c: OrderedTree2<Node>) {
//        core = c
//    }
//    
//    /// O(1)
//    var isEmpty: Bool {
//        return core.isEmpty
//    }
//    /// O(1)
//    var count: Int {
//        return core.count
//    }
//    /// O(depth)
//    func count(at index: Index) -> Int {
//        return core.count(at: index)
//    }
//    /// O(depth ^ 2)
//    func count(at path: Path) -> Int {
//        return count(at: index(of: path))
//    }
//    /// O(depth)
//    func contains(_ index: Index) -> Bool {
//        return core.contains(at: index)
//    }
//    /// O(depth)
//    func contains(_ path: Path) -> Bool {
//        return contains(index(of: path))
//    }
//    /// O(depth)
//    func subtree(at index: Index) -> FileTree2 {
//        return FileTree2(core.subtree(at: index))
//    }
//    /// O(depth)
//    func subtree(at path: Path) -> FileTree2 {
//        return subtree(at: index(of: path))
//    }
//    /// O(depth)
//    func path(for index: Index) -> Path {
//        guard index != .root else { return .root }
//        let (firstIndex, lastIndexPath) = index.splitFirstComponent()
//        let firstNode = subtree.at(firstIndex)
//        let firstName = firstNode.name
//        let lastNames = path(for: lastIndexPath)
//        return Path(components: [first] + lastNames)
//    }
//    /// O(depth ^ 2)
//    func index(of path: Path) -> Index {
//        guard path != .root else { return .root }
//        let (pp, name) = path.splitLastComponent()
//        let pidx = index(of: pp)
//        let cc = core.count(at: pidx)
//        for i in 0..<cc {
//            let idx = pidx.appendingLastComponent(i)
//            let n = core.at(idx)
//            if n.name == name {
//                return pidx.appendingLastComponent(i)
//            }
//        }
//        fatalError("Cannot find index of the path `\(path)`.")
//    }
//
//    /// O(depth) ~ O(n)
//    mutating func insert(at index: Index, _ node: Node) {
//        core.insert(at: index, node)
//    }
//    /// O(depth) ~ O(n)
//    mutating func update(at index: Index, _ node: Node) {
//        core.update(at: index, node)
//    }
//    /// O(depth) ~ O(n)
//    mutating func remove(at index: Index) {
//        core.remove(at: index)
//    }
//
//    /// O(depth ^ 2) ~ O(n)
//    mutating func insert(at path: Path, _ node: Node) {
//        let idx = index(of: path)
//        core.insert(at: idx, node)
//    }
//    /// O(depth ^ 2) ~ O(n)
//    mutating func update(at path: Path, _ node: Node) {
//        let idx = index(of: path)
//        core.update(at: idx, node)
//    }
//    /// O(depth ^ 2) ~ O(n)
//    mutating func remove(at path: Path) {
//        let idx = index(of: path)
//        core.remove(at: idx)
//    }
//}
//extension FileTree3 {
//    struct Node {
//        var name: String
//    }
//}

