//
//  ApplyMainMenuAction.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

extension State {
    mutating func apply(action: MainMenuAction) throws {
        switch action {
        case .FileNewFile:
            MARK_unimplemented()

        case .FileNewWorkspace:
            let id = WorkspaceID()
            workspaces[id] = WorkspaceState()
            currentWorkspaceID = id

        case .FileOpenWorkspace:
            MARK_unimplemented()

        case .FileCloseWorkspace:
            guard let id = currentWorkspaceID else { throw StateError.RollbackByMissingPrerequisites }
            guard workspaces[id] != nil else { throw StateError.RollbackByMissingPrerequisites }
            workspaces[id] = nil

        default:
            MARK_unimplemented()
        }
    }
}