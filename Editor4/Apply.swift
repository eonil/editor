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
    mutating func apply(action: UserAction) throws {
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
        case .File(let action):
            try process(id) { workspaceState in
                try applyOnWorkspace(&workspaceState, action: action)
            }
        default:
            MARK_unimplemented()
        }
    }
    private mutating func applyOnWorkspace(inout workspace: WorkspaceState, action: FileAction) throws {
        switch action {
        case .CreateFolderAndStartEditingName(let containerFileID, let newFileIndex, let newFolderName):
            try workspace.createFolder(in: containerFileID, at: newFileIndex, with: newFolderName)

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
            try workspace.deleteFiles(fileIDs)

        case .SetHighlightedFile(let maybeNewFileID):
            workspace.window.navigatorPane.file.selection.reset(maybeNewFileID)

        case .StartEditingCurrentFileName:
            guard workspace.window.navigatorPane.file.selection.getHighlightOrCurrent() != nil else { throw UserInteractionError.missingCurrentFile }
            workspace.window.navigatorPane.file.editing = true

        case .SetSelectedFiles(let currentFileID, let itemFileIDs):
            workspace.window.navigatorPane.file.selection.reset(currentFileID, itemFileIDs)

        case .Rename(let fileID, let newName):
            let fileState = workspace.files[fileID]
            if fileID == workspace.files.rootID {
                // TODO: Support renaming of root node to rename the workspace...
                MARK_unimplemented()
            }
            else {
                let oldName = fileState.name
                guard newName != oldName else { throw UserInteractionError.CannotRenameFileBecauseNewNameIsEqualToOldName }
                guard workspace.files.queryAllSiblingFileStatesOf(fileID).contains({ $0.name == newName }) == false else { throw UserInteractionError.CannotRenameFileBecauseSameNameAlreadyExists }
                try workspace.files.rename(fileID, to: newName)
                assert(workspace.files.journal.logs.last != nil)
                assert(workspace.files.journal.logs.last!.operation.isUpdate == true)
                assert(workspace.files.journal.logs.last!.operation.key == fileID)
            }

        default:
            MARK_unimplemented()
        }
    }

    private mutating func apply(n: Notification) throws {
        switch n {
        case .Cargo(let n):
            switch n {
            case .Step(let newState):
                cargo = newState
            }
        case .Platform(let n):
            switch n {
            case .ReloadWorkspace(let workspaceID, let newWorkspaceState):
                assert(newWorkspaceState.location != nil)
                try process(workspaceID) { workspaceState in
                    workspaceState = newWorkspaceState
                }
            }
        }
    }
}


private extension FileTree2 {
//    private func querySuperfileStateOf(fileID: FileID2) -> FileState2? {
//        guard let superfileID = self[fileID].superfileID else { return nil }
//        return self[superfileID]
//    }
    private func queryAllSiblingFileStatesOf(fileID: FileID2) -> AnySequence<FileState2> {
        guard let superfileID = self[fileID].superfileID else { return AnySequence([]) }
        return AnySequence(self[superfileID].subfileIDs.map({ self[$0] }))
    }
}




































