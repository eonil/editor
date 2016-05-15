//
//  ApplyMainMenuAction.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import BoltsSwift

func apply(action: MainMenuAction, inout to state: State, with services: Services) throws {
    switch action {
    case .FileNewWorkspace:
        let id = WorkspaceID()
        state.workspaces[id] = WorkspaceState()

    case .FileNewFolder:
        guard state.currentWorkspace != nil else { throw MainMenuActionError.MissingCurrentWorkspace }
        try state.currentWorkspace?.appendNewFolderOnCurrentFolder()

    case .FileNewFile:
        guard state.currentWorkspace != nil else { throw MainMenuActionError.MissingCurrentWorkspace }
        try state.currentWorkspace?.appendNewFileOnCurrentFolder()

    case .FileOpenWorkspace:
        MARK_unimplemented()

    case .FileCloseWorkspace:
        guard let id = state.currentWorkspaceID else { throw StateError.RollbackByMissingPrerequisites }
        guard state.workspaces[id] != nil else { throw StateError.RollbackByMissingPrerequisites }
        state.workspaces[id] = nil

    case .ProductBuild:
        guard let workspaceID = state.currentWorkspaceID else { throw MainMenuActionError.MissingCurrentWorkspace }
        try services.cargo.run(.Build).continueWith(.MainThread, continuation: { (task: Task<()>) -> () in
            services.dispatch(Action.Workspace(id: workspaceID, action: WorkspaceAction.UpdateBuildState))
        })

    case .ProductClean:
        guard let workspaceID = state.currentWorkspaceID else { throw MainMenuActionError.MissingCurrentWorkspace }
        try services.cargo.run(.Clean).continueWith(.MainThread, continuation: { (task: Task<()>) -> () in
            services.dispatch(Action.Workspace(id: workspaceID, action: WorkspaceAction.UpdateBuildState))
        })

//        case .ProductRun:
//        case .ProductStop:

    default:
        MARK_unimplemented()
    }
}
