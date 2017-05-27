//
//  RepoProjectTreeController.swift
//  Editor6
//
//  Created by Hoon H. on 2017/03/08.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import Buckets
import Editor6Common
import Editor6WorkspaceModel
import Editor6WorkspaceUI
import Editor6FileTreeUI
///
/// Manages conversion between model and view state
/// of project file tree.
///
final class RepoProjectTreeController {
    private var ms = ProjectState()
    private var vs = FileNavigatorUIState()
    private var idMapping = Bimap<ProjectItemID, FileNavigatorUINodeID>()

//    private typealias ModelNodeID = ProjectItemID
//    private typealias ViewNodeID = WorkspaceUIBasicOutlineNodeID

    init() {
        idMapping[key: ProjectItemID([])] = vs.tree.root.id
    }
    func apply(_ t: ProjectTransaction) {
        switch t {
        case let .insert(p, r, cs):
            precondition(r.count == cs.count)
            guard let vpid = idMapping[key: mpid] else { MARK_unimplemented() }
            for (i, c) in zip(r, cs) {
                let vpid =
                vs.tree.insert(at: i, in: p)
            }
            for i in r {

            }
        case let .update(p, r, cs):

        case let .delete(p, r, cs):
        }
    }
    func apply(_ m: Tree1Mutation<ProjectItemID, ProjectItemState>) {
        func makeFileName(_ m: ProjectItemID) -> String {
            return m.segments.last ?? "????"
        }
        switch m {
        case .insert(let a):
            for (mid,ms,idx,mpid) in a {
                guard let vpid = idMapping[key: mpid] else { MARK_unimplemented() }
                var vcs = FileNavigatorUINodeState()
                vcs.name = makeFileName(mid)
                let vcid = vs.tree.insert(vcs, at: idx, in: vpid)
                idMapping[key: mid] = vcid
            }
        case .update(let a):
            for (mid,ms,idx,mpid) in a {
                guard let vcid = idMapping[key: mid] else { MARK_unimplemented() }
                vs.tree[vcid].name = makeFileName(mid)
            }
        case .delete(let a):
            for (mid,_,_,_) in a {
                guard let vcid = idMapping[key: mid] else { MARK_unimplemented() }
                vs.tree.remove(vcid)
                idMapping[key: mid] = nil
            }
        }
        MARK_unimplemented()
//        switch m {
//        case .insert(let kvs):
//            for (k, v) in kvs {
//                let vid = WorkspaceUIBasicOutlineNodeID()
//                reverseIDMapping[vid] = k
//                let parentModelID = k.removingLastItem()
//                ms.items[parentModelID].
//            }
//            vs.navigator.files.tree
//        case .update(let kvs):
//
//        case .delete(let kvs):
//
//        }
    }
}
