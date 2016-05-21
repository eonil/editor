//
//  FileNodePath.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// Key-based path to designate a file node.
/// This is far slower than index-based path, but does not get invalidated.
/// This path is proper for serialization to be persist.
struct FileNodePath {
    /// `[]` is root node.
    /// `["folder1"]` is subnode of root node with name `folder`.
    /// `["folder1", "file2"]` is subnode of above node with name `file2`.
    var keys = [String]()
    init(_ keys: [String]) {
        self.keys = keys
    }
    func splitFirst() -> (first: String, tail: FileNodePath)? {
        guard let first = keys.first else { return nil }
        let rest = keys[keys.startIndex.successor()..<keys.endIndex]
        return (first, FileNodePath(Array(rest)))
    }
    func splitLast() -> (head: FileNodePath, last: String)? {
        guard let last = keys.last else { return nil }
        let rest = keys[keys.startIndex..<keys.endIndex.predecessor()]
        return (FileNodePath(Array(rest)), last)
    }
    func prependingFirst(key: String) -> FileNodePath {
        return FileNodePath([key] + keys)
    }
    func appendingLast(key: String) -> FileNodePath {
        return FileNodePath(keys + [key])
    }
}
/// Index-based path to designate a file node.
/// This path is very fast, but gets invalidated after any mutation has been
/// applied to the tree.
struct FileNodeIndex {
    /// `[]` is root node.
    /// `[3]` is 3rd subnode of root node.
    /// `[3,1]` is 1st subnode of above node.
    var indexes = [Int]()
    init(_ indexes: [Int]) {
        self.indexes = indexes
    }
    func splitFirst() -> (first: Int, tail: FileNodeIndex)? {
        guard let first = indexes.first else { return nil }
        let rest = indexes[indexes.startIndex.successor()..<indexes.endIndex]
        return (first, FileNodeIndex(Array(rest)))
    }
    func splitLast() -> (head: FileNodeIndex, last: Int)? {
        guard let last = indexes.last else { return nil }
        let rest = indexes[indexes.startIndex..<indexes.endIndex.predecessor()]
        return (FileNodeIndex(Array(rest)), last)
    }
}
