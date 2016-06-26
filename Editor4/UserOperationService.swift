//
//  UserOperationService.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import BoltsSwift

/// Manages all long-running operations.
///
final class UserOperationService: DriverAccessible {
    private let toolset = Toolset()

    /// **NOT IMPLEMENTED YET!!!**
    /// Abstracts user file name editing operation.
    ///
    /// 1. This becomes non-nil value when user starts editing of a file name
    ///     in file navigator.
    /// 2. The task completes when user commits changes.
    /// 3. Any error or cancellation would produce faulted/cancelled task respectively.
    /// 4. This task becomes nil when user finishes editing operaiton regardless of
    ///     result status. After setting task result.
    ///
    private var EXPERIMENTAL_editingFileName: TaskCompletionSource<()>?

    /// **NOT IMPLEMENTED YET!!!**
    /// Abstracts create-new-folder operation.
    /// 1. Creates a new node.
    /// 2. Start editing of the node.
    /// 3. Accepts user input.
    /// 4. User finishes editing. Results to a file-ID if succeeded.
    ///
    private var EXPERIMENTAL_createNewFolder: TaskCompletionSource<FileID2>?

    /// Runs a command.
    ///
    /// - Returns:
    ///     A task which completes when the operation
    ///     completes which has been triggered by this
    ///     command.
    func dispatch(command: UserOperationCommand) -> Task<()> {
        return driver.ADHOC_queryUserInteractionState().continueWithTask { [driver, weak self] task in
            guard let S = self else { return Task.cancelledTask() }
            guard let state = task.result else { return Task.cancelledTask() }
            do {
                return try S.run(state: state, command: command).continueWithTask(continuation: { [weak self] (task: Task<()>) -> Task<()> in
                    if task.faulted {
                        guard let error = task.error else { fatalError("`Task.faulted == true` with no error object.") }
                        self?.driver.dispatch(Action.Shell(ShellAction.Alert(error)))
                        reportErrorToDevelopers(error)
                    }
                    return task
                })
            }
            catch let error {
                reportErrorToDevelopers(error)
                driver.dispatch(Action.Shell(ShellAction.Alert(error)))
                return Task(error: error)
            }
        }
    }
}

enum UserOperationError: ErrorType {
//    case CannotRunTheCommandInCurrnetState
    case MissingCurrentWorkspace
    case MissingCurrentWorkspaceLocation
    case MissingCurrentFile
    case NoSelectedFile
    case File(FileUserOperationError)
    case BadFileURL
    case MissingWorkspace(WorkspaceID)
    case CannotResolvePathForWorkspaceFile((WorkspaceID, FileID2))
    case CannotMakeNewURL(oldURL: NSURL, newName: String)
}
enum FileUserOperationError {
    case CannotMakeNameForNewFolder
    case CannotFindNewlyCreatedFolderID
    case BadPath(FileNodePath)
}

extension UserOperationService {
    /// Runs a long-running command.
    /// This method is also responsible to determine executability of the command.
    /// This is also responsible for concurrency management. Some command can be
    /// executed if they can be executed concurrently.
    ///
    /// Whatever you run, running status must be dispatched to `State` using `dispatch(Action)`
    /// to be rendered to user.
    ///
    private func run(state state: UserInteractionState, command: UserOperationCommand) throws -> Task<()> {
        assertMainThread()
        switch command {
        case .RunMenuItem(let command):
            switch command {
            case .Main(let command):
                return try run(state: state, command: command)
            case .FileNavigator(let command):
                return try run(state: state, command: command)
            }

        case .UserInteraction(let command):
            return try run(state: state, command: command)
        }
    }
    private func run(state state: UserInteractionState, command: MainMenuCommand) throws -> Task<()> {
        assertMainThread()
        let driver = self.driver
        switch command {
        case .FileNewWorkspace:
            var u1: NSURL?
            return DialogueUtility.runFolderSaveDialogue().continueOnSuccessWithTask(continuation: { [toolset] (u: NSURL) -> Task<()> in
                assert(u.fileURL)
                guard u.fileURL else { return Task(error: UserOperationError.BadFileURL) }
                u1 = u
                return toolset.cargo.dispatch(CargoCommand.New(u))
                
            }).continueWithTask(Executor.MainThread, continuation: { [toolset] (task: Task<()>) -> Task<()> in
                let workspaceID = WorkspaceID()
                driver.dispatch(.Workspace(workspaceID, .Open))
                driver.dispatch(.Workspace(workspaceID, .Reconfigure(location: u1)))
                return task
            })

        case .FileNewFolder:
            guard let workspaceID = state.currentWorkspaceID else { throw UserOperationError.MissingCurrentWorkspace }
            guard let workspace = state.currentWorkspace else { throw UserOperationError.MissingCurrentWorkspace }
            guard let currentFileID = workspace.window.navigatorPane.file.selection.getHighlightOrCurrent() else { throw UserOperationError.MissingCurrentFile }
            let currentFilePath = workspace.files.resolvePathFor(currentFileID)
            guard let newFolderName = (0..<128)
                .map({ "(new folder" + $0.description + ")" })
                .filter({ workspace.queryFile(currentFileID, containsSubfileWithName: $0) == false })
                .first else { throw UserOperationError.File(FileUserOperationError.CannotMakeNameForNewFolder) }
            guard let u = workspace.location?.appending(currentFilePath) else { throw UserOperationError.File(FileUserOperationError.BadPath(currentFilePath)) }
            let u1 = u.URLByAppendingPathComponent(newFolderName)
            return driver.run(PlatformCommand.CreateDirectoryWithIntermediateDirectories(u1)).continueOnSuccessWithTask(continuation: { () -> Task<()> in
                return driver.dispatch(.Workspace(workspaceID, .File(.CreateFolderAndStartEditingName(container: currentFileID, index: 0, name: newFolderName))))
            }).continueOnSuccessWithTask(continuation: { () -> Task<()> in
                guard let newWorkspaceState = state.workspaces[workspaceID] else { throw UserOperationError.MissingCurrentWorkspace }
                return driver.run(PlatformCommand.StoreWorkspace(newWorkspaceState))
            })

        case .FileNewFile:
            guard let workspaceID = state.currentWorkspaceID else { throw UserOperationError.MissingCurrentWorkspace }
            guard let workspace = state.currentWorkspace else { throw UserOperationError.MissingCurrentWorkspace }
            guard let currentFileID = workspace.window.navigatorPane.file.selection.getHighlightOrCurrent() else { throw UserOperationError.MissingCurrentFile }
            let currentFilePath = workspace.files.resolvePathFor(currentFileID)
            guard let newFileName = (0..<128)
                .map({ "(new file" + $0.description + ")" })
                .filter({ workspace.queryFile(currentFileID, containsSubfileWithName: $0) == false })
                .first else { throw UserOperationError.File(FileUserOperationError.CannotMakeNameForNewFolder) }
            guard let u = workspace.location?.appending(currentFilePath) else { throw UserOperationError.File(FileUserOperationError.BadPath(currentFilePath)) }
            let u1 = u.URLByAppendingPathComponent(newFileName)
            return driver.run(PlatformCommand.CreateDataFileWithIntermediateDirectories(u1)).continueOnSuccessWithTask(continuation: { () -> Task<()> in
                return driver.dispatch(.Workspace(workspaceID, .File(.CreateFileAndStartEditingName(container: currentFileID, index: 0, name: newFileName))))
            }).continueOnSuccessWithTask(continuation: { () -> Task<()> in
                guard let newWorkspaceState = state.workspaces[workspaceID] else { throw UserOperationError.MissingCurrentWorkspace }
                return driver.run(PlatformCommand.StoreWorkspace(newWorkspaceState))
            })


        case .FileOpenWorkspace:
            var u1: NSURL?
            return DialogueUtility.runFolderOpenDialogue().continueOnSuccessWithTask(continuation: { [toolset] (u: NSURL) -> Task<()> in
                assert(u.fileURL)
                guard u.fileURL else { return Task(error: UserOperationError.BadFileURL) }
                u1 = u
                return Task(())
            }).continueOnSuccessWithTask(continuation: { () -> Task<()> in
                guard let u1 = u1 else { return Task(()) }
                let workspaceID = WorkspaceID()
                driver.dispatch(.Workspace(workspaceID, .Open))
                driver.dispatch(.Workspace(workspaceID, .SetCurrent))
                driver.dispatch(.Workspace(workspaceID, .Reconfigure(location: u1)))
                return driver.run(PlatformCommand.RestoreWorkspace(workspaceID, location: u1))
            })

        case .FileCloseWorkspace:
            guard let workspaceID = state.currentWorkspaceID else { throw UserOperationError.MissingCurrentWorkspace }
            return driver.dispatch(Action.Workspace(workspaceID, WorkspaceAction.Close))

        case .FileDelete:
            guard let workspaceID = state.currentWorkspaceID else { throw UserOperationError.MissingCurrentWorkspace }
            guard let workspace = state.currentWorkspace else { throw UserOperationError.MissingCurrentWorkspace }
            guard let location = workspace.location else { throw UserOperationError.MissingCurrentWorkspaceLocation }
            let fileSequenceToDelete = workspace.window.navigatorPane.file.selection.getHighlightOrItems()
            let uniqueFileIDs = Set(fileSequenceToDelete)
            let us = uniqueFileIDs.map { (fileID: FileID2) -> NSURL in
                let p = workspace.files.resolvePathFor(fileID)
                let u = location.appending(p)
                return u
            }
            return driver.run(PlatformCommand.DeleteFileSubtrees(us)).continueOnSuccessWithTask(continuation: { () -> Task<()> in
                return driver.dispatch(Action.Workspace(workspaceID, WorkspaceAction.File(FileAction.DeleteFiles(uniqueFileIDs))))
            }).continueOnSuccessWithTask(continuation: { () -> Task<()> in
                guard let newWorkspaceState = state.workspaces[workspaceID] else { throw UserOperationError.MissingCurrentWorkspace }
                return driver.run(PlatformCommand.StoreWorkspace(newWorkspaceState))
            })

        case .FileShowInFinder:
            guard let currentWorkspace = state.currentWorkspace else { throw UserOperationError.MissingCurrentWorkspace }
            guard let location = currentWorkspace.location else { throw UserOperationError.MissingCurrentWorkspaceLocation }
            func getContainerFolderURL(fileID: FileID2) -> NSURL {
                let path = currentWorkspace.files.resolvePathFor(fileID)
                let url = location.appending(path)
                return url
            }
            let allFileIDsToShow = currentWorkspace.window.navigatorPane.file.selection.getHighlightOrItems()
            // All selections should be lazy collection, and evaluating for existence of first element must be O(1).
            guard allFileIDsToShow.isEmpty == false else { throw UserOperationError.NoSelectedFile }
            let containerFolderURLs = allFileIDsToShow.map(getContainerFolderURL)
            return driver.run(PlatformCommand.OpenFileInFinder(containerFolderURLs))

        case .FileShowInTerminal:
            MARK_unimplemented()

        case .ProductBuild:
            guard let currentWorkspaceLocation = state.currentWorkspace?.location else { throw UserOperationError.MissingCurrentWorkspaceLocation }
            return toolset.cargo.dispatch(CargoCommand.Build(currentWorkspaceLocation))

        case .ProductClean:
            guard let currentWorkspaceLocation = state.currentWorkspace?.location else { throw UserOperationError.MissingCurrentWorkspaceLocation }
            return toolset.cargo.dispatch(CargoCommand.Clean(currentWorkspaceLocation))

    //        case .ProductRun:
    //        case .ProductStop:

        default:
            MARK_unimplemented()
        }
    }
    private func run(state state: UserInteractionState, command: FileNavigatorMenuCommand) throws -> Task<()> {
        assertMainThread()
        switch command {
        case .ShowInFinder:
            return driver.run(UserOperationCommand.RunMenuItem(MenuCommand.Main(MainMenuCommand.FileShowInFinder)))

        case .ShowInTerminal:
            return driver.run(UserOperationCommand.RunMenuItem(MenuCommand.Main(MainMenuCommand.FileShowInTerminal)))

        case .CreateNewFolder:
            return driver.run(UserOperationCommand.RunMenuItem(MenuCommand.Main(MainMenuCommand.FileNewFolder)))

        case .CreateNewFile:
            return driver.run(UserOperationCommand.RunMenuItem(MenuCommand.Main(MainMenuCommand.FileNewFile)))

        case .Delete:
            return driver.run(UserOperationCommand.RunMenuItem(MenuCommand.Main(MainMenuCommand.FileDelete)))
        }
    }
}

extension UserOperationService {
    private func run(state state: UserInteractionState, command: UserInteractionCommand) throws -> Task<()> {
        assertMainThread()
        let driver = self.driver
        switch command {
        case .Rename(let workspaceID, let fileID, let newName):
            guard let workspace = state.workspaces[workspaceID] else { throw UserOperationError.MissingWorkspace(workspaceID) }
            let filePath = workspace.files.resolvePathFor(fileID)
            guard let oldURL = workspace.location?.appending(filePath) else { throw UserOperationError.CannotResolvePathForWorkspaceFile(workspaceID, fileID) }
            guard let newURL = oldURL.URLByDeletingLastPathComponent?.URLByAppendingPathComponent(newName) else { throw UserOperationError.CannotMakeNewURL(oldURL: oldURL, newName: newName) }
            // Hope file-system operation to be fast enough.
            return driver.run(PlatformCommand.RenameFile(from: oldURL, to: newURL)).continueOnSuccessWithTask(continuation: { () -> Task<()> in
                // Update UI only if file-system operation is successful.
                return driver.dispatch(Action.Workspace(workspaceID, WorkspaceAction.File(FileAction.Rename(fileID, newName: newName))))
                    .continueWithTask(continuation: { (task: Task<()>) -> Task<()> in
                        // Store workspace at last.
                        guard let newWorkspaceState = state.workspaces[workspaceID] else { throw UserOperationError.MissingWorkspace(workspaceID) }
                        return driver.run(PlatformCommand.StoreWorkspace(newWorkspaceState)).continueWithTask(continuation: { (task: Task<()>) -> Task<()> in
                            if task.faulted {
                                // If we couldn't store workspace, it's a serious issue.
                                // For now, I have no idea how to deal with this, so
                                // just crash.
                                // TODO: Figure out better policy.
                                reportErrorToDevelopers("`PlatformCommand.StoreWorkspace` failed with error `\(task.error)`.")
                                fatalError("`PlatformCommand.StoreWorkspace` failed with error `\(task.error)`.")
                            }
                            return task
                        })
                    })
            })
        }
    }
}










////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private extension WorkspaceState {
    func queryFile(superfileID: FileID2, containsSubfileWithName subfileName: String) -> Bool {
        return files[superfileID].subfileIDs.contains { files[$0].name == subfileName }
    }
}







