//
//  WorkspaceAccessible.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit

protocol WorkspaceAccessible {
    var workspaceID: WorkspaceID? { get }
}
extension WorkspaceAccessible where Self: DriverAccessible {
    var workspaceState: WorkspaceState? {
        get {
            guard let workspaceID = workspaceID else { return nil }
            return state.workspaces[workspaceID]
        }
    }
}