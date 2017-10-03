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
    case project(ProjectFeature.Command)
    case codeEditing(CodeEditingFeature.Command)
    case build(BuildFeature.Command)
    case spawn(Process)

    enum Process {
        case renameFile(at: IndexPath, with: String)

        ///
        /// This command may cause some user-interaction during process.
        ///
        /// This tries these steps.
        /// - Move file on system.
        /// - If fails, for any reason, it spawns an alert.
        ///   Potential reasons.
        ///   - Any file-system error.
        /// - Logical bugs crash program.
        ///   - A file does not exist at `from` path.
        ///   - A file already exists at `to` path.
        ///
        case moveFile(from: IndexPath, to: IndexPath)

//        ///
//        /// This command may cause some user-interaction during process.
//        ///
//        /// This tries these steps.
//        /// - Move file on system.
//        /// - If fails, for any reason, it spawns an alert.
//        ///   Potential reasons.
//        ///   - A file does not exist at `from` path.
//        ///   - A file already exists at `to` path.
//        ///   - Any file-system error.
//        ///
//        case moveFileByNamePath(from: ProjectItemPath, to: ProjectItemPath)
    }
}
