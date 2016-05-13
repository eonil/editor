//
//  FileNode.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/13.
//  Copyright © 2016 Eonil. All rights reserved.
//

struct FileNavigatorState: VersioningStateType {
    private(set) var version = Version()
    var tree = FileNode() {
        didSet { revise() }
    }
    var selection = [FileNodePath]() {
        didSet { revise() }
    }
    private mutating func revise() {
        version.revise()
    }
}
enum FileNavigatorError: ErrorType {
//    case BadFileNodeID
    case BadFileNodePath
}

////////////////////////////////////////////////////////////////
//typealias FileNode = IndexJournalingTreeNode<FileNodeState>
struct FileNode: VersioningStateType {
    private typealias InternalNode = IndexJournalingTreeNode<FileNodeState>
    private var internalNode: InternalNode
    var version: Version {
        get { return internalNode.version }
    }
    var state: FileNodeState {
        get { return internalNode.payload }
        set { internalNode.payload = newValue }
    }
    var subnodes: FileNodeArray {
        get { return FileNodeArray(internalNode.subnodes) }
        set { internalNode.subnodes = newValue.internalArray }
    }
    init() {
        internalNode = InternalNode(payload: FileNodeState())
    }
    init(state: FileNodeState) {
        internalNode = InternalNode(payload: state)
    }
    private init(internalNode: InternalNode) {
        self.internalNode = internalNode
    }
}
struct FileNodeArray: IndexJournalingArrayType {
    typealias Element = FileNode
    private typealias InternalArray = IndexJournalingArray<FileNode.InternalNode>
    private var internalArray: InternalArray
    private init(_ internalArray: InternalArray) {
        self.internalArray = internalArray
    }
    var version: Version {
        get { return internalArray.version }
    }
    var journal: IndexJournal {
        get { return internalArray.journal }
    }
    var count: Int {
        get { return internalArray.count }
    }
    func indexOf(predicate: FileNode throws -> Bool) rethrows -> Int? {
        return try internalArray.indexOf { (element: InternalArray.Element) throws -> Bool in
            return try predicate(FileNode(internalNode: element))
        }
    }
    mutating func insert(newElement: FileNode, atIndex: Int) {
        internalArray.insert(newElement.internalNode, atIndex: atIndex)
    }
    mutating func removeAtIndex(index: Int) -> FileNode {
        return FileNode(internalNode: internalArray.removeAtIndex(index))
    }
}
extension FileNodeArray: CollectionType {
    var startIndex: Int {
        get { return internalArray.startIndex }
    }
    var endIndex: Int {
        get { return internalArray.endIndex }
    }
    subscript(index: Int) -> FileNode {
        get { return FileNode(internalNode: internalArray[index]) }
        set { internalArray[index] = newValue.internalNode }
    }
}
extension FileNodeArray: SequenceType {
    func generate() -> AnyGenerator<FileNode> {
        var g = internalArray.generate()
        return AnyGenerator {
            guard let next = g.next() else { return nil }
            return FileNode(internalNode: next)
        }
    }
}

extension FileNode {
    func findIndexForPath(path: FileNodePath) -> FileNodeIndex? {
        guard path.keys.count > 0 else { return FileNodeIndex([]) }
        guard let (first, rest) = path.splitFirst() else { return FileNodeIndex([]) }
        guard let firstIndex = findIndexOfSubnodeForName(first) else { return FileNodeIndex([]) }
        guard let restIndexes = subnodes[firstIndex].findIndexForPath(rest) else { return FileNodeIndex([]) }
        return FileNodeIndex([firstIndex] + restIndexes.indexes)
    }
    private func findIndexOfSubnodeForName(name: String) -> Int? {
        return subnodes.indexOf { $0.state.name == name }
    }
    subscript(name: String) -> FileNode? {
        get {
            guard let index = findIndexOfSubnodeForName(name) else { return nil }
            return subnodes[index]
        }
        set {
            guard let index = findIndexOfSubnodeForName(name) else { return }
            guard let newValue = newValue else {
                subnodes.removeAtIndex(index)
                return
            }
            subnodes[index] = newValue
        }
    }
    subscript(index: FileNodeIndex) -> FileNode {
        get { return FileNode(internalNode: internalNode[index.indexes]) }
        set { internalNode[index.indexes] = newValue.internalNode }
    }
//    /// - Parameter index:
//    ///     Empty index is not allowed.
//    mutating func removeAtIndex(index: FileNodeIndex) throws -> FileNode? {
//        switch index.indexes.count {
//        case 0:
//            throw FileActionError.BadFileNodeIndex
//        case 1:
//            guard let (first, _) = index.splitFirst() else { throw FileActionError.BadFileNodeIndex }
//            return subnodes.removeAtIndex(first)
//
//        default:
//            guard let (first, tail) = index.splitFirst() else { throw FileActionError.BadFileNodeIndex }
//            return try subnodes[first].removeAtIndex(tail)
//        }
//    }
}

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
    func splitFirst() -> (String, FileNodePath)? {
        guard let first = keys.first else { return nil }
        let rest = keys[keys.startIndex.successor()..<keys.endIndex]
        return (first, FileNodePath(Array(rest)))
    }
    func splitLast() -> (FileNodePath, String)? {
        guard let last = keys.last else { return nil }
        let rest = keys[keys.startIndex..<keys.endIndex.predecessor()]
        return (FileNodePath(Array(rest)), last)
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

////////////////////////////////////////////////////////////////
struct FileNodeState {
    var name = ""
    var comment: String?
    var isGroup = true
}










