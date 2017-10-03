//
//  Tree.extension.FileTree.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/03.
//Copyright © 2017 Eonil. All rights reserved.
//

import EonilTree

extension Tree where Node == ProjectFeature.FileNode {
    ///
    /// O(depth)
    ///
    func namePath(at indexPath: IndexPath) -> ProjectItemPath {
        switch indexPath.count {
        case 0:
            return ProjectItemPath(components: [node.name])
        default:
            let (i, indexSubpath) = indexPath.splitFirst()
            return subtrees[i].namePath(at: indexSubpath)
        }
    }
    func indexPath(at namePath: ProjectItemPath) -> IndexPath {
        MARK_unimplemented()
    }
}

internal extension IndexPath {
    func splitFirst() -> (Int, IndexPath) {
        precondition(count > 0)
        return (self[0], self[0...])
    }
    func splitLast() -> (IndexPath, Int) {
        precondition(count > 0)
        let i = endIndex - 1
        return (self[..<i], self[i])
    }
}
