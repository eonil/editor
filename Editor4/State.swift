//
//  State.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

// If copying cost becomes too big, consider using of COW objects.

struct State {
    /// Currently selected workspace.
    ///
    /// Window ordering and main-window state are managed
    /// by AppKit and we don't care. Then why do we need
    /// to track current main-window? To send main-menu
    /// command to correct window.
    var currentWorkspaceID: WorkspaceID? = nil
//    var mainMenu = MainMenuState()
    var workspaces = KeyJournalingDictionary<WorkspaceID, WorkspaceState>()
    var services = ServiceState()
}
extension State {
    /// Accesses current workspace state.
    /// Settings back to this property will update `WorkspaceState` for `currentWorkspaceID`.
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

//struct MainMenuState {
//    var runnableCommands = Set<MainMenuCommand>()
//    var build
//}

struct ServiceState {
    var cargo = CargoServiceState()
}