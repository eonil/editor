//
//  WorkspaceIssue.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/08.
//Copyright © 2017 Eonil. All rights reserved.
//

enum WorkspaceIssue {
    case plan(PlanFeature.ProcessIssue)
    case project(ProjectFeature.ProcessIssue)
    case codeEditing(CodeEditingFeature.ProcessIsse)
    case build(BuildFeature.ProcessIssue)
    case debug
}
