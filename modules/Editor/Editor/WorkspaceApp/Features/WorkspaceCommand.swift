//
//  WorkspaceCommand.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

enum WorkspaceCommand {
    case menu(MainMenuItemID)
    case plan(PlanFeature.Command)
    case dialogue(DialogueFeature.Command)
    case codeEditing(CodeEditingFeature.Command)
    case build(BuildFeature.Command)
}
