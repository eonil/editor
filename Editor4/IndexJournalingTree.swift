//
//  IndexJournalingTree.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/12.
//  Copyright © 2016 Eonil. All rights reserved.
//

enum IndexJournalingTreeNodeError: ErrorType {
    case BadIndexPath
}

/// A tree-node that journals mutations in subnodes list.
///
/// If you change `payload`, it will trigger super-node's mutation,
/// and you can track changes on container.
///
struct IndexJournalingTreeNode<Payload>: VersioningStateType {
    typealias Error = IndexJournalingTreeNodeError
    typealias Subnodes = IndexJournalingArray<IndexJournalingTreeNode<Payload>>

    ////////////////////////////////////////////////////////////////
    private(set) var version = Version()
    var payload: Payload {
        didSet { revise() }
    }
    var subnodes: Subnodes {
        didSet { revise() }
    }

    ////////////////////////////////////////////////////////////////
    init(payload: Payload) {
        self.payload = payload
        self.subnodes = Subnodes()
    }
    init(payload: Payload, journalingCapacityLimit: Int) {
        self.payload = payload
        self.subnodes = Subnodes(journalingCapacityLimit: journalingCapacityLimit)
    }
    private mutating func revise() {
        version.revise()
    }
}
extension IndexJournalingTreeNode {
    subscript(indexPath: [Int]) -> IndexJournalingTreeNode {
        get { return self[indexPath[0..<indexPath.count]] }
        set { self[indexPath[0..<indexPath.count]] = newValue }
    }
    subscript(indexPath: ArraySlice<Int>) -> IndexJournalingTreeNode {
        get {
            switch indexPath.count {
            case 0:
                return self
            case 1:
                return subnodes[indexPath[0]]
            default:
                let subpath = indexPath[1..<indexPath.count]
                return subnodes[indexPath[0]][subpath]
            }
        }
        set {
            switch indexPath.count {
            case 0:
                self = newValue
            case 1:
                subnodes[indexPath[0]] = newValue
            default:
                let subpath = indexPath[1..<indexPath.count]
                subnodes[indexPath[0]][subpath] = newValue
            }
        }
    }
}
















