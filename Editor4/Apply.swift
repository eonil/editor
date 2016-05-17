//
//  Apply.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//


extension State {
    mutating func apply(transaction: Transaction) throws {
        switch transaction {
        case .Reset:
            self = State()

        case .Test(let transaction):
            apply(transaction)

        case .Shell(let transaction):
            applyOnShell((), transaction: transaction)

        case .Workspace(let id, let transaction):
            try apply(id , transaction: transaction)

        case .ApplyCargoServiceState(let state):
            services.cargo = state
        }
    }

    private mutating func apply(transaction: TestTransaction) {
        switch transaction {
        case .Test1:
            print("Test1")

        case .Test2CreateWorkspaceAt(let u):
//            cargo
            break
        }
    }

    /// Shell is currently single, so it doesn't have an actual ID,
    /// but an ID is required to be passed to shape interface consistent.
    private mutating func applyOnShell(id: (), transaction: ShellTransaction) {
        MARK_unimplemented()
    }
    private mutating func apply(id: WorkspaceID, transaction: WorkspaceTransaction) throws {
        switch transaction {
        case .Open:
            workspaces[id] = WorkspaceState()

        case .SetCurrent:
            currentWorkspaceID = id

        case .Reconfigure(let location):
            workspaces[id]?.location = location

        case .Close:
            workspaces[id] = nil

        case .File(let transaction):
            try applyOnWorkspace(&workspaces[id]!, transaction: transaction)

        default:
            MARK_unimplemented()
        }
    }
    private mutating func applyOnWorkspace(inout workspace: WorkspaceState, transaction: FileTransaction) throws {
        switch transaction {
        case .Select(let paths):
            workspace.window.navigatorPane.file.selection = paths

        default:
            MARK_unimplemented()
        }
    }
}








































