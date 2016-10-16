//
//  DriverState.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

/// Application central state repository.
///
/// "Central" means this is application-wide shared data.
/// "Central" doesn't mean the `Driver` would manage all the states.
/// Each components owns and manages thier own state, and dispatches
/// back some to driver. Driver collects them for its needs. Usually
/// as parameters to derive central state.
///
/// Main concern of driver state is managing main menu.
struct DriverState {
    /// `WorkspaceDocument` owns and manages the workspace state.
    /// And workspace document dispatches its state back to `Driver` when
    /// changed. These aggregated workspaces states works as parameters
    /// to update driver local state.
    private(set) var workspaces = [WorkspaceID: WorkspaceState]()
    private(set) var currentWorkspaceID = WorkspaceID?.none
    private(set) var mainMenu = MainMenuState()

    mutating func apply(event: WorkspaceDocumentEvent) {
        switch event {
        case .initiate(let workspace):
            workspaces[workspace.id] = workspace.state
        case .renew(let workspace):
            workspaces[workspace.id] = workspace.state
        case .terminate(let workspace):
            workspaces[workspace.id] = nil
        case .becomeCurrent(let workspaceID):
            currentWorkspaceID = workspaceID
        case .resignCurrent(let workspaceID):
            guard currentWorkspaceID == workspaceID else { reportFatalError() }
            currentWorkspaceID = nil
        }
    }
}

typealias Workspace = (id: WorkspaceID, state: WorkspaceState)

struct WorkspaceID: Hashable {
    private var oid: ObjectIdentifier
    static func from(document: WorkspaceDocument) -> WorkspaceID {
        return WorkspaceID(oid: ObjectIdentifier(document))
    }
    var hashValue: Int {
        return oid.hashValue
    }

    static func == (_ a: WorkspaceID, _ b: WorkspaceID) -> Bool {
        return a.oid == b.oid
    }
}

struct WorkspaceState {
    var files = [URL]()
    var issues = [String]()
    var debug = DebugState()
}

struct DebugState {
    var processes = [DebugProcessState]()
}
typealias DebugProcess = (id: DebugProcessID, state: DebugProcessState)
typealias DebugProcessID = pid_t
struct DebugProcessState {
    var threads = [DebugThreadState]()
    var processName = ""
}
typealias DebugThread = (id: DebugThreadID, state: DebugThreadState)
typealias DebugThreadID = thread_t
struct DebugThreadState {
    var threadName = ""
}
typealias DebugFrame = (id: DebugFrameID, state: DebugFrameState)
typealias DebugFrameID = Int32
struct DebugFrameState {
    var functionName = ""
}







