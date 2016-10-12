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
