//
//  State.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// Root container of all user-interaction state.
///
/// This does not contain much things. Each workspaces contain most
/// data.
///
/// Each workspaces has thier own databases.
/// Workspace contains `window` which represents whole navigation stack.
///
/// - Note:
///     If copying cost becomes too big, consider using of COW objects.
///
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
    var toolset = ToolsetState()
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
            guard let workspaceID = currentWorkspaceID else {
                reportErrorToDevelopers("Assigning back to this property is not a critical error, but this is not likely to be a proper mutation.")
                return
            }
            workspaces[workspaceID] = newValue
        }
    }
}

//struct MainMenuState {
//    var runnableCommands = Set<MainMenuCommand>()
//    var build
//}

struct ToolsetState {
    var cargo = CargoServiceState()
}