//
//  RepoProjectTreeController.swift
//  Editor6
//
//  Created by Hoon H. on 2017/03/08.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import Editor6Common
import Editor6WorkspaceModel
import Editor6WorkspaceUI

///
/// Manages conversion between model and view state
/// of project file tree.
///
final class RepoProjectTreeController {
    private var ms = ProjectState()
    private var vs = WorkspaceUIBasicOutlineState()
    private var reverseIDMapping = [WorkspaceUIBasicOutlineNodeID: ProjectItemID]()

//    private typealias ModelNodeID = ProjectItemID
//    private typealias ViewNodeID = WorkspaceUIBasicOutlineNodeID

    init() {
        
    }
    func apply(_ m: DictionaryMutation<ProjectItemID, ProjectItemState>) {
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
