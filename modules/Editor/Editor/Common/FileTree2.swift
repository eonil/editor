//
//  FileTree2.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

struct FileTree2 {
    typealias Path = ProjectItemPath
    typealias Index = OrderedTree2<Node>.IndexPath
    private var core = OrderedTree2<Node>()

    /// O(1)
    init() {}
    /// O(1)
    private init(_ c: OrderedTree2<Node>) {
        core = c
    }
    
    /// O(1)
    var isEmpty: Bool {
        return core.isEmpty
    }
    /// O(1)
    var count: Int {
        return core.count
    }
    /// O(depth)
    func count(at index: Index) -> Int {
        return core.count(at: index)
    }
    /// O(depth ^ 2)
    func count(at path: Path) -> Int {
        return count(at: index(of: path))
    }
    /// O(depth)
    func contains(_ index: Index) -> Bool {
        return core.contains(at: index)
    }
    /// O(depth)
    func contains(_ path: Path) -> Bool {
        return contains(index(of: path))
    }
    /// O(depth)
    func subtree(at index: Index) -> FileTree2 {
        return FileTree2(core.subtree(at: index))
    }
    /// O(depth)
    func subtree(at path: Path) -> FileTree2 {
        return subtree(at: index(of: path))
    }
    /// O(depth ^ 2)
    func path(for index: Index) -> Path {
        guard index != .root else { return .root }
        let (pidx, _) = index.splitLastComponent()
        let pp = path(for: pidx)
        let n = core.at(index)
        return pp.appendingComponent(n.name)
    }
    /// O(depth ^ 2)
    func index(of path: Path) -> Index {
        guard path != .root else { return .root }
        let (pp, name) = path.splitLastComponent()
        let pidx = index(of: pp)
        let cc = core.count(at: pidx)
        for i in 0..<cc {
            let idx = pidx.appendingLastComponent(i)
            let n = core.at(idx)
            if n.name == name {
                return pidx.appendingLastComponent(i)
            }
        }
        fatalError("Cannot find index of the path `\(path)`.")
    }

    /// O(depth) ~ O(n)
    mutating func insert(at index: Index, _ node: Node) {
        core.insert(at: index, node)
    }
    /// O(depth) ~ O(n)
    mutating func update(at index: Index, _ node: Node) {
        core.update(at: index, node)
    }
    /// O(depth) ~ O(n)
    mutating func remove(at index: Index) {
        core.remove(at: index)
    }

    /// O(depth ^ 2) ~ O(n)
    mutating func insert(at path: Path, _ node: Node) {
        let idx = index(of: path)
        core.insert(at: idx, node)
    }
    /// O(depth ^ 2) ~ O(n)
    mutating func update(at path: Path, _ node: Node) {
        let idx = index(of: path)
        core.update(at: idx, node)
    }
    /// O(depth ^ 2) ~ O(n)
    mutating func remove(at path: Path) {
        let idx = index(of: path)
        core.remove(at: idx)
    }
}
extension FileTree2 {
    struct Node {
        var name: String
    }
}
