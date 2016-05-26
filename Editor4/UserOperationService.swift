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
    private let services = Services()

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
        do {
            return try run(command).continueWithTask(continuation: { [weak self] (task: Task<()>) -> Task<()> in
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

enum UserOperationError: ErrorType {
//    case CannotRunTheCommandInCurrnetState
    case MissingCurrentWorkspace
    case MissingCurrentWorkspaceLocation
    case MissingCurrentFile
    case NoSelectedFile
    case File(FileUserOperationError)
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
    private func run(command: UserOperationCommand) throws -> Task<()> {
        switch command {
        case .RunMenuItem(let command):
            switch command {
            case .Main(let command):
                return try run(command)
            case .FileNavigator(let command):
                return try run(command)
            }
        }
    }
    private func run(command: MainMenuCommand) throws -> Task<()> {
        let driver = self.driver
        switch command {
        case .FileNewWorkspace:
//            guard services.cargo.state.isRunning == false else { throw UserOperationError.CannotRunTheCommandInCurrnetState }
            var u1: NSURL?
            return DialogueUtility.runFolderSaveDialogue().continueOnSuccessWithTask(continuation: { [services] (u: NSURL) -> Task<()> in
                u1 = u
                return try services.cargo.run(.New(u))
            }).continueWithTask(Executor.MainThread, continuation: { [services] (task: Task<()>) -> Task<()> in
                driver.dispatch(.ApplyCargoServiceState(services.cargo.state))
                let workspaceID = WorkspaceID()
                driver.dispatch(.Workspace(workspaceID, .Open))
                driver.dispatch(.Workspace(workspaceID, .Reconfigure(location: u1)))
                return task
            })

        case .FileNewFolder:
            guard let workspaceID = driver.userInteractionState.currentWorkspaceID else { throw UserOperationError.MissingCurrentWorkspace }
            guard let workspace = driver.userInteractionState.currentWorkspace else { throw UserOperationError.MissingCurrentWorkspace }
            guard let currentFileID = workspace.window.navigatorPane.file.selection.getHighlightOrCurrent() else { throw UserOperationError.MissingCurrentFile }
            return driver.dispatch(Action.Workspace(workspaceID, WorkspaceAction.File(FileAction.CreateFolderAndStartEditingName(container: currentFileID, index: 0))))

        case .FileNewFile:
            guard let workspaceID = driver.userInteractionState.currentWorkspaceID else { throw UserOperationError.MissingCurrentWorkspace }
            guard let workspace = driver.userInteractionState.currentWorkspace else { throw UserOperationError.MissingCurrentWorkspace }
            guard let currentFileID = workspace.window.navigatorPane.file.selection.getHighlightOrCurrent() else { throw UserOperationError.MissingCurrentFile }
            return driver.dispatch(Action.Workspace(workspaceID, WorkspaceAction.File(FileAction.CreateFileAndStartEditingName(container: currentFileID, index: 0))))
//            guard state.currentWorkspace != nil else { throw MainMenuActionError.MissingCurrentWorkspace }
//            try state.currentWorkspace?.appendNewFileOnCurrentFolder()
//
//        case .FileOpenWorkspace:
//            MARK_unimplemented()
//
//        case .FileCloseWorkspace:
//            guard let id = state.currentWorkspaceID else { throw StateError.RollbackByMissingPrerequisites }
//            guard state.workspaces[id] != nil else { throw StateError.RollbackByMissingPrerequisites }
//            state.workspaces[id] = nil
//

        case .FileDelete:
            guard let workspaceID = driver.userInteractionState.currentWorkspaceID else { throw UserOperationError.MissingCurrentWorkspace }
            guard let workspace = driver.userInteractionState.currentWorkspace else { throw UserOperationError.MissingCurrentWorkspace }
            let fileSequenceToDelete = workspace.window.navigatorPane.file.selection.getHighlightOrItems()
            let uniqueFileIDs = Set(fileSequenceToDelete)
            return driver.dispatch(Action.Workspace(workspaceID, WorkspaceAction.File(FileAction.DeleteFiles(uniqueFileIDs))))

    //    case .ProductBuild:
    //        guard let workspaceID = state.currentWorkspaceID else { throw MainMenuActionError.MissingCurrentWorkspace }
    //        try services.cargo.run(.Build).continueWith(.MainThread, continuation: { (task: Task<()>) -> () in
    //            services.dispatch(Action.Workspace(id: workspaceID, action: WorkspaceAction.UpdateBuildState))
    //        })
    //
    //    case .ProductClean:
    //        guard let workspaceID = state.currentWorkspaceID else { throw MainMenuActionError.MissingCurrentWorkspace }
    //        try services.cargo.run(.Clean).continueWith(.MainThread, continuation: { (task: Task<()>) -> () in
    //            services.dispatch(Action.Workspace(id: workspaceID, action: WorkspaceAction.UpdateBuildState))
    //        })

    //        case .ProductRun:
    //        case .ProductStop:

        default:
            MARK_unimplemented()
        }
    }
    private func run(command: FileNavigatorMenuCommand) throws -> Task<()> {
        switch command {
        case .ShowInFinder:
            guard let currentWorkspace = driver.userInteractionState.currentWorkspace else { throw UserOperationError.MissingCurrentWorkspace }
            guard let location = currentWorkspace.location else { throw UserOperationError.MissingCurrentWorkspaceLocation }
            func getContainerFolderURL(fileID: FileID2) -> NSURL {
                let path = currentWorkspace.files.resolvePathFor(fileID)
                let url = location.appending(path)
                return url
            }
            let allFileIDsToShow = currentWorkspace.window.navigatorPane.file.selection.getHighlightOrItems()
            // All selections should be lazy collection, and evaluating for existence of first element must be O(1).
            guard allFileIDsToShow.isEmpty else { throw UserOperationError.NoSelectedFile }
            let containerFolderURLs = allFileIDsToShow.map(getContainerFolderURL)
            return driver.run(PlatformCommand.OpenFileInFinder(containerFolderURLs))

        case .ShowInTerminal:
            MARK_unimplemented()

        case .CreateNewFolder:
            return driver.run(UserOperationCommand.RunMenuItem(MenuCommand.Main(MainMenuCommand.FileNewFolder)))

        case .CreateNewFile:
            return driver.run(UserOperationCommand.RunMenuItem(MenuCommand.Main(MainMenuCommand.FileNewFile)))

        case .Delete:
            return driver.run(UserOperationCommand.RunMenuItem(MenuCommand.Main(MainMenuCommand.FileDelete)))
        }
    }
}












