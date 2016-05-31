//
//  Apply.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

private struct Dummy: DriverAccessible {}
private extension State {
    private var driver: Driver {
        get { return Dummy().driver }
    }
}

extension State {
    mutating func apply(action: Action) throws {
        switch action {
        case .Reset:
            self = State()

        case .Test(let action):
            apply(action)

        case .Shell(let action):
            try applyOnShell((), action: action)

        case .Workspace(let id, let action):
            try apply(id , action: action)

        case .Notify(let notification):
            try apply(notification)
        }
    }
    private mutating func apply(action: TestAction) {
        switch action {
        case .Test1:
            print("Test1")

        case .Test2CreateWorkspaceAt(let u):
//            cargo
            break
        }
    }

    /// Shell is currently single, so it doesn't have an actual ID,
    /// but an ID is required to be passed to shape interface consistent.
    private mutating func applyOnShell(id: (), action: ShellAction) throws {
        switch action {
        case .Alert(let error):
            // This will trigger outer loop to render the error.
            throw error

        default:
            MARK_unimplemented()
        }
    }
    private mutating func apply(id: WorkspaceID, action: WorkspaceAction) throws {
        switch action {
        case .Open:
            workspaces[id] = WorkspaceState()

        case .SetCurrent:
            currentWorkspaceID = id

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
        case .CreateFolderAndStartEditingName(let containerFileID, let newFileIndex, let newFolderName):
            let newFolderState = FileState2(form: FileForm.Container,
                                            phase: FilePhase.Editing,
                                            name: newFolderName)
            let newFolderID = try workspace.files.insert(newFolderState, at: newFileIndex, to: containerFileID)
            workspace.window.navigatorPane.file.selection.reset(newFolderID)
            workspace.window.navigatorPane.file.editing = true

        case .CreateFileAndStartEditingName(let containerFileID, let newFileIndex, let newFileName):
            let newFolderState = FileState2(form: FileForm.Data,
                                            phase: FilePhase.Editing,
                                            name: newFileName)
            let newFolderID = try workspace.files.insert(newFolderState, at: newFileIndex, to: containerFileID)
            workspace.window.navigatorPane.file.selection.reset(newFolderID)
            workspace.window.navigatorPane.file.editing = true

        case .DeleteAllCurrentOrSelectedFiles:
            let fileSequenceToDelete = workspace.window.navigatorPane.file.selection.getHighlightOrItems()
            let uniqueFileIDs = Set(fileSequenceToDelete)
            workspace.window.navigatorPane.file.selection.reset()
            for fileID in uniqueFileIDs {
                workspace.files.remove(fileID)
            }

        case .DeleteFiles(let fileIDs):
            let unknownFileIDs = fileIDs.filter({ workspace.files.contains($0) == false })
            guard unknownFileIDs.count == 0 else { throw UserInteractionError.UnknownFiles(Array(unknownFileIDs)) }
            workspace.window.navigatorPane.file.selection.reset()
            for fileID in fileIDs {
                guard workspace.files.contains(fileID) else { continue } // A file node can be erased by prior deletion.
                workspace.files.remove(fileID)
            }

        case .SetHighlightedFile(let maybeNewFileID):
            workspace.window.navigatorPane.file.selection.reset(maybeNewFileID)

        case .StartEditingCurrentFileName:
            guard workspace.window.navigatorPane.file.selection.getHighlightOrCurrent() != nil else { throw UserInteractionError.MissingCurrentFile }
            workspace.window.navigatorPane.file.editing = true

        case .SetSelectedFiles(let currentFileID, let itemFileIDs):
            workspace.window.navigatorPane.file.selection.reset(currentFileID, itemFileIDs)

        default:
            MARK_unimplemented()
        }
    }

    private mutating func apply(n: Notification) throws {
        switch n {
        case .Cargo(let n):
            switch n {
            case .Step(let newState):
                toolset.cargo = newState
            }
        case .Platform(let n):
            switch n {
            case .ReloadWorkspace(let workspaceID, let workspaceState):
                assert(workspaceState.location != nil)
                workspaces[workspaceID] = workspaceState
            }
        }
    }
}







































