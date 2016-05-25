//
//  WorkspaceAccessible.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit

protocol WorkspaceAccessible {
}
extension WorkspaceAccessible where Self: NSViewController {
    /// Gets workspace ID bound to self.
    var workspaceID: WorkspaceID? {
        get {
            guard let workspaceWindowController = view.window?.windowController as? WorkspaceWindowController else { return nil }
            guard let workspaceID = workspaceWindowController.workspaceID else { return nil }
            return workspaceID
        }
    }
}
extension WorkspaceAccessible where Self: DriverAccessible, Self: NSViewController {
    var workspaceState: WorkspaceState? {
        get {
            guard let workspaceID = workspaceID else { return nil }
            return driver.userInteractionState.workspaces[workspaceID]
        }
    }
}


