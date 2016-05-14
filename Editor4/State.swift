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
    /// Keep journal as many as possible becasue we need to track them precisely as much as possible.
    /// Anyway, if you make mutations over the limit, view will remake all windows.  
    var workspaces = KeyJournalingDictionary<WorkspaceID, WorkspaceState>(journalingCapacityLimit: Int.max)
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