//
//  Apply.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//


extension State {
    mutating func apply(action: Action) throws {
        switch action {
        case .Reset:
            self = State()

        case .Test(let action):
            apply(action)

        case .Menu(let action):
            try apply(action)

        case .Shell(let action):
            applyOnShell((), action: action)

        case .Workspace(let id, let action):
            applyOnWorkspace(id , action: action)
        }
    }

    private mutating func apply(action: TestAction) {
        switch action {
        case .Test1:
            print("Test1")
        }
    }

    /// Shell is currently single, so it doesn't have an actual ID,
    /// but an ID is required to be passed to shape interface consistent.
    private mutating func applyOnShell(id: (), action: ShellAction) {
        MARK_unimplemented()
    }
    private mutating func applyOnWorkspace(id: WorkspaceID, action: WorkspaceAction) {
        switch action {
        case .Open:
            workspaces[id] = WorkspaceState()

        case .Reconfigure(let location):
            workspaces[id]?.location = location

        case .Close:
            workspaces[id] = nil
            
        default:
            MARK_unimplemented()
        }
    }
}








































