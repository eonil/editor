//
//  ProjectSelection.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/24.
//  Copyright © 2017 Eonil. All rights reserved.
//

struct ProjectSelection {
    var snapshot: ProjectFeature.FileTree
    var indexPaths: AnySequence<IndexPath>

    init() {
        snapshot = ProjectFeature.FileTree(node: ProjectFeature.FileNode.root) // This is bogus value.
        indexPaths = AnySequence([])
    }
    init(snapshot: ProjectFeature.FileTree, indexPaths: AnySequence<IndexPath>) {
        self.snapshot = snapshot
        self.indexPaths = indexPaths
    }
    init(snapshot: ProjectFeature.FileTree, outlineSelection: TreeOutlineAdapter2<ProjectFeature.FileNode>.Selection) {
        self.snapshot = snapshot
        self.indexPaths = AnySequence(outlineSelection)
    }
}

/////
///// Immutable collection of `ProjectItemPath`s
///// which represents selection.
/////
///// MUST be guaranteed to be sorted in DFS manner.
/////
//protocol ProjectSelection: Sequence where Element == ProjectItemPath {
//}
//struct AnyProjectSelection: ProjectSelection {
//    private let impl: () -> AnyIterator<ProjectItemPath>
//    init() {
//        impl = { AnyIterator({ nil }) }
//    }
//    init<T>(_ raw: T) where T: ProjectSelection {
//        impl = { AnyIterator(raw.makeIterator()) }
//    }
//    init(snapshot: ProjectFeature.FileTree, selection: TreeOutlineAdapter2<ProjectFeature.FileNode>.Selection) {
//        impl = {
//            let idxpsIter = selection.makeIterator()
//            return AnyIterator { () -> ProjectItemPath? in
//                guard let idxp = idxpsIter.next() else { return nil }
//                return snapshot.namePath(at: idxp)
//            }
//        }
//    }
//    func makeIterator() -> AnyIterator<ProjectItemPath> {
//        return impl()
//    }
//}
//extension ProjectSelection {
//    static var none: AnyProjectSelection {
//        return AnyProjectSelection()
//    }
//}

