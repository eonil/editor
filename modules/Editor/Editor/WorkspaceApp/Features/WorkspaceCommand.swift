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
    case spawn(Process)

    enum Process {
        ///
        /// This command may cause some user-interaction during process.
        ///
        /// This tries these steps.
        /// - Move file on system.
        /// - If fails, for any reason, it spawns an alert.
        ///   Potential reasons.
        ///   - A file does not exist at `from` path.
        ///   - A file already exists at `to` path.
        ///   - Any file-system error.
        ///
        case moveFile(from: ProjectItemPath, to: ProjectItemPath)
    }
}
