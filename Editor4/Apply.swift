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
            try apply(id , action: action)
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
    private mutating func apply(id: WorkspaceID, action: WorkspaceAction) throws {
        switch action {
        case .Open:
            workspaces[id] = WorkspaceState()

        case .Reconfigure(let location):
            workspaces[id]?.location = location

        case .Close:
            workspaces[id] = nil

        case .File(let action):
            try applyOnWorkspace(&workspaces[id]!, action: action)

        default:
            MARK_unimplemented()
        }
    }
    private mutating func applyOnWorkspace(inout workspace: WorkspaceState, action: FileAction) throws {
        switch action {
        case .CreateFolder(let containerFilePath, let index, let name):
            guard let containerFileID = workspace.files.searchFileIDForPath(containerFilePath) else { throw FileActionError.BadFileNodePath(containerFilePath) }
            try workspace.files.insert(FileState2(form: .Container, name: name), at: index, to: containerFileID)

        case .CreateFile(let containerFilePath, let index, let name):
            guard let containerFileID = workspace.files.searchFileIDForPath(containerFilePath) else { throw FileActionError.BadFileNodePath(containerFilePath) }
            try workspace.files.insert(FileState2(form: .Data, name: name), at: index, to: containerFileID)

        case .SelectNodes(let paths):
            workspace.window.navigatorPane.file.selection = paths

        case .ADHOC_Test1:
//            let rootFileState = workspace.files[workspace.files.rootID]
//            guard let last = rootFileState.subfileIDs.last else { return }
//            workspace.files.remove(last)
//            for (k,v) in workspace.files {
//                debugLog(v)
//            }
            break

        default:
            MARK_unimplemented()
        }
    }
}








































