//
//  State.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

// If copying cost becomes too big, consider using of COW objects.

struct State {
    /// Current key-window.
    /// Window ordering and key-window state are managed
    /// by AppKit and we don't care. Then why do we need
    /// to track current key-window? To send main-menu
    /// command to correct window.
    var currentWorkspaceID: WorkspaceID? = nil
    /// Workspaces.
    var workspaces = KeyJournalingDictionary<WorkspaceID, WorkspaceState>()
}
extension State {
    var currentWorkspace: WorkspaceState? {
        get {
            guard let workspaceID = currentWorkspaceID else { return nil }
            return workspaces[workspaceID]
        }
        set {
            guard let workspaceID = currentWorkspaceID else { return }
            workspaces[workspaceID] = newValue
        }
    }
}