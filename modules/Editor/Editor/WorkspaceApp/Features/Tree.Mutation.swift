//
//  Tree.Mutation.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/05.
//Copyright © 2017 Eonil. All rights reserved.
//

import EonilTree

extension Tree {
    enum Mutation {
        case insert(at: IndexPath)
        case replace(at: IndexPath)
        case remove(at: IndexPath)
    }
    ///
    /// Optimized mutation representation for use with AppKit's `NSOutlineView`.
    ///
    /// As `NSOutlineView` needs proxy reference-type object for optimized operation,
    /// replacing a subtree at arbitrary location require updating of all its subproxy
    /// objects, which is O(n) operation. If user just updated `node` data, this kind
    /// of update is just a waste of time. By using `replaceNode` mutation, you can
    /// update `node` of a tree in O(1) time.
    ///
    enum OptimizedMutation {
        case replaceNode(at: IndexPath)
    }

//    mutating func apply(_ m: Mutation, _ finalVersionSnapshot: Tree) {
//        switch m {
//        case .insert(let path):
//            precondition(path.isEmpty == false, "You cannot insert at root because result cannot be defined.")
//            let newSubtree = finalVersionSnapshot[path]
//            let (containerPath, contentIndex) = path.splitLast()
//            self[containerPath].subtrees.insert(newSubtree, at: contentIndex)
//        case .replace(let path):
//            // Updating root is allowed.
//            let newSubtree = finalVersionSnapshot[path]
//            if path.isEmpty {
//                self = newSubtree
//            }
//            else {
//                let (containerPath, contentIndex) = path.splitLast()
//                self[containerPath].subtrees[contentIndex] = newSubtree
//            }
//        case .remove(let path):
//            precondition(path.isEmpty == false, "You cannot delete root because result cannot be defined..")
//            let (containerPath, contentIndex) = path.splitLast()
//            self[containerPath].subtrees.remove(at: contentIndex)
//        }
//    }
//    mutating func apply(_ m: OptimizedMutation, _ finalVersionSnapshot: Tree) {
//        switch m {
//        case .replaceNode(let path):
//            let newNode = finalVersionSnapshot[path].node
//            self[path].node = newNode
//        }
//    }

//    ///
//    /// Replaces subtree at `path` to a new value.
//    ///
//    /// - Parameter path:
//    ///     Designate subtree to replace.
//    ///     This can be an empty path to designate whole tree
//    ///     (root subtree), and in that case, the value SHOULD
//    ///     NOT be `nil`.
//    ///
//    /// - Parameter subtree:
//    ///     New value for the designated subtree.
//    ///     If
//    ///
//    mutating func replace(at path: IndexPath, with subtree: Tree?) {
//    }
}
