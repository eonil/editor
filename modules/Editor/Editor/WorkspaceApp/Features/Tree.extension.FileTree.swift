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
            return ProjectItemPath()
        default:
            let (i, indexSubpath) = indexPath.splitFirst()
            let subtree = subtrees[i]
            let nameSubpath = subtree.namePath(at: indexSubpath)
            let namep = ProjectItemPath([subtree.node.name]).appending(nameSubpath)
            return namep
        }
    }
    ///
    /// More than O(depth * average width)
    ///
    func indexPath(at namePath: ProjectItemPath) -> IndexPath? {
        switch namePath.components.count {
        case 0:
            return IndexPath()
        default:
            let (name, nameSubpath) = namePath.splitFirst()
            for i in 0..<subtrees.count {
                let subtree = subtrees[i]
                if subtree.node.name == name {
                    guard let subidxp = subtree.indexPath(at: nameSubpath) else { return nil }
                    let idxp = IndexPath(index: i).appending(subidxp)
                    return idxp
                }
            }
            return nil
        }
    }
}

