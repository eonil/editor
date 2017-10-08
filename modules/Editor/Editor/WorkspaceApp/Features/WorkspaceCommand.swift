//
//  WorkspaceCommand.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

enum WorkspaceCommand {
    case menu(MainMenuItemID)
    case dialogue(DialogueFeature.Command)
    case project(ProjectFeature.Command)
    case codeEditing(CodeEditingFeature.Command)
    case build(BuildFeature.Command)
    case plan(PlanFeature.Command)
//    case spawn(Process)
//    enum Process {
//
//    }
}
