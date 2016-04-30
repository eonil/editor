//
//  Apply.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// If the update result is equal4
enum StateApplicationRollback: ErrorType {
    case Cancel
}

extension State {
    mutating func apply(action: Action) throws {
        switch action {
        case .Menu(let mainMenuItemID):
            MARK_unimplemented()

        case .Shell(let action):
            applyOnShell((), action: action)

        case .Workspace(let id, let action):
            applyOnWorkspace(id , action: action)
        }
    }

    /// Shell is currently single, so it doesn't have an actual ID,
    /// but an ID is required to be passed to shape interface consistent.
    private mutating func applyOnShell(id: (), action: ShellAction) {

    }
    private mutating func applyOnWorkspace(id: WorkspaceID, action: WorkspaceAction) {

    }
}