//
//  ApplyMainMenuAction.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

extension State: Dispatchable {
    mutating func apply(action: MainMenuAction) throws {
        switch action {
        case .FileNewWorkspace:
            let id = WorkspaceID()
            workspaces[id] = WorkspaceState()

        case .FileNewFolder:
            guard currentWorkspace != nil else { throw MainMenuActionError.MissingCurrentWorkspace }
            try currentWorkspace?.appendNewFolderOnCurrentFolder()

        case .FileNewFile:
            guard currentWorkspace != nil else { throw MainMenuActionError.MissingCurrentWorkspace }
            try currentWorkspace?.appendNewFileOnCurrentFolder()

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