//
//  ProjectMutation.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import Editor6Common

public enum ProjectMutation {
    case items(Tree1Mutation<ProjectItemID, ProjectItemState>)
}
