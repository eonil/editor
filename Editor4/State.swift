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
    private(set) var version = Version()

    /// Currently selected workspace.
    ///
    /// Window ordering and main-window state are managed
    /// by AppKit and we don't care. Then why do we need
    /// to track current main-window? To send main-menu
    /// command to correct window.
    var currentWorkspaceID: WorkspaceID? = nil {
        didSet { version.revise() }
    }
//    var mainMenu = MainMenuState()
    private(set) var workspaces = KeyJournalingDictionary<WorkspaceID, WorkspaceState>() {
        didSet { version.revise() }
    }

    var cargo = CargoServiceState() {
        didSet { version.revise() }
    }
    
    /// Will be dispatched from `DebugService`.
    private(set) var debug = DebugState() {
        didSet { version.revise() }
    }

    mutating func revise() {
        version.revise()
    }
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

extension State {
    mutating func process<T>(workspaceID: WorkspaceID, @noescape _ transaction: (inout WorkspaceState) throws -> T) throws -> T {
        guard let workspaceState = workspaces[workspaceID] else { throw StateError.missingWorkspaceStateFor(workspaceID) }
        var workspaceState1 = workspaceState
        let result = try transaction(&workspaceState1)
        workspaces[workspaceID] = workspaceState1
        return result
    }
    mutating func addWorkspace() -> WorkspaceID {
        let workspaceID = WorkspaceID()
        workspaces[workspaceID] = WorkspaceState()
        return workspaceID
    }
    mutating func removeWorkspace(workspaceID: WorkspaceID) throws {
        if currentWorkspaceID == workspaceID {
            currentWorkspaceID = nil
        }
        guard workspaces[workspaceID] != nil else { throw StateError.missingWorkspaceStateFor(workspaceID) }
        precondition(workspaces.removeValueForKey(workspaceID) != nil)
    }
    mutating func reloadWorkspace(workspaceID: WorkspaceID, workspaceState: WorkspaceState) throws {
        guard workspaces[workspaceID] != nil else { throw StateError.missingWorkspaceStateFor(workspaceID) }
        workspaces[workspaceID] = workspaceState
    }
    mutating func reviseDebugState(newDebugState: DebugState) {
        debug = newDebugState
    }
}

extension State {
    mutating func clearJournals() {
        workspaces.clearJournal()
    }
}

//struct ToolsetState {
//    var cargo = CargoServiceState()
//}

















