////
////  FileNode2.swift
////  Editor4
////
////  Created by Hoon H. on 2016/05/13.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//struct FileNavigatorState: VersionedStateType {
//    private(set) var version = Version()
//    private(set) var root = FileNodeID()
//    private(set) var nodes = Dictionary<FileNodeID, FileNodeState>()
//    private(set) var tree = FileNode(payload: FileNodeState())
//    private(set) var selection = [FileNodeID]()
//
//    //    init() {
//    //        nodes[root] = FileNodeState(name: "", comment: nil, isGroup: true, subnodes: [])
//    //    }
//}
//enum FileNavigatorError: ErrorType {
//    //    case BadFileNodeID
//    case BadFileNodePath
//}
//typealias FileNode = IndexJournalingTreeNode<FileNodeState>
//struct FileNodePayload {
//    private(set) var state = FileNodeState()
//    private(set) var subnodes = [FileNodeID]()
//}
//extension IndexJournalingTreeNode where Payload: FileNodeState {
//    //    subscript(indexPath: [Int]) -> FileNodeState {
//    //
//    //    }
//    //    mutating func addNode(state: FileNodeState, at indexPath: [Int]) throws {
//    //        switch indexPath.count {
//    //        case 0:
//    //            throw FileNavigatorError.BadFileNodePath
//    //        case 1:
//    //            self.subnodes.append(IndexJournalingTreeNode(payload: state))
//    //
//    //        default:
//    //            self.subnodes[path.first!].addNode(state, at: path[1..<indexPath.connt])
//    //        }
//    //    }
//    //    mutating func removeNodeAt(indexPath: [Int]) throws {
//    //
//    //    }
//}
//extension FileNavigatorState {
//    mutating func addNode(id: FileNodeID, at path: [Int]) throws {
//        guard let insertionIndex = path.last else { throw FileNavigatorError.BadFileNodePath }
//        let parentPath = path[0..<path.count.predecessor()]
//        for index in parentPath {
//
//        }
//    }
//    //    mutating func addNode(child: FileNodeID, to parent: FileNodeID, with state: FileNodeState) throws {
//    //        guard nodes[parent] != nil else { throw "File node ID `\(parent) is missing in tree.`" }
//    //        guard nodes[child] == nil else { throw "File node ID `\(child) must be missing in tree.`" }
//    //        guard nodes[parent]!.subnodes.indexOf(child) == nil else { throw "Child `\(child)` must be missing in parent `\(parent)`." }
//    //        nodes[child] = state
//    //        nodes[parent]!.subnodes.append(child)
//    //    }
//    //    mutating func removeNode(child: FileNodeID, from parent: FileNodeID) throws {
//    //        guard nodes[parent] != nil else { throw "File node ID `\(parent) is missing in tree.`" }
//    //        guard nodes[child] != nil else { throw "File node ID `\(child) must be missing in tree.`" }
//    //        guard nodes[parent]!.subnodes.indexOf(child) != nil else { throw "Child `\(child)` is missing in parent `\(parent)`." }
//    //        nodes[parent]!.subnodes.removeAtIndex(nodes[parent]!.subnodes.indexOf(child)!)
//    //        nodes[child] = nil
//    //    }
//    //    mutating func setNode(id: FileNodeID, name: String, comment: String?, isGroup: Bool) throws {
//    //        guard nodes[id] != nil else { throw "File node ID `\(id) is missing in tree.`" }
//    //        nodes[id]!.name = name
//    //        nodes[id]!.comment = comment
//    //        nodes[id]!.isGroup = isGroup
//    //    }
//}
/////// Represents identity of a file node.
///////
/////// Intentionally uses object pointer based ID to provide
/////// optimization to view part. Because `NSOutlineView` needs
/////// pointer based identification of each node to work properly.
////struct FileNodeID: Hashable {
////    var hashValue: Int {
////        get { return oid.hashValue }
////    }
////    private let oid: ObjectAddressID
////    init() {
////        self.oid = ObjectAddressID()
////    }
////}
////func == (a: FileNodeID, b: FileNodeID) -> Bool {
////    return a.oid == b.oid
////}
////extension FileNodeID {
////    init?(objectForOptimizationOnly: AnyObject) {
////        guard let o = objectForOptimizationOnly as? ObjectAddressID else { return nil }
////        self.oid = o
////    }
////    /// Same ID always returns same object.
////    /// Doesn't seem to be a trult good approach. Maybe I have to implement
////    /// versioning-tree.
////    func asObjectForOptimizationOnly() -> AnyObject {
////        return oid.asObject()
////    }
////}
//struct FileNodeState {
//    private(set) var version = Version()
//    private(set) var name = ""
//    private(set) var comment: String?
//    private(set) var isGroup = true
//    //    private(set) var subnodes = [FileNodeID]()
//}
