//
//  OperationService.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import BoltsSwift

/// Manages all long-running operations.
///
struct OperationService: DriverAccessible {
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
}
enum OperationError: ErrorType {
    case CannotRunTheCommandInCurrnetState
    case MissingCurrentWorkspace
    case MissingCurrentFile
    case File(FileOperationError)
}
enum FileOperationError {
    case CannotMakeNameForNewFolder
    case CannotFindNewlyCreatedFolderID
    case BadPath(FileNodePath)
}

extension OperationService {
    /// Runs a long-running command.
    /// This method is also responsible to determine executability of the command.
    /// This is also responsible for concurrency management. Some command can be
    /// executed if they can be executed concurrently.
    ///
    /// Whatever you run, running status must be dispatched to `State` using `dispatch(Action)`
    /// to be rendered to user.
    ///
    func run(command: Command) throws -> Task<()> {
        switch command {
        case .RunMainMenuItem(let command):
            return try run(command)
        }
    }
    private func run(command: MainMenuCommand) throws -> Task<()> {
        let driver = self.driver
        switch command {
        case .FileNewWorkspace:
//            guard services.cargo.state.isRunning == false else { throw OperationError.CannotRunTheCommandInCurrnetState }
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
            guard let workspaceID = driver.state.currentWorkspaceID else { throw OperationError.CannotRunTheCommandInCurrnetState }
            guard let workspace = driver.state.currentWorkspace else { throw OperationError.MissingCurrentFile }
            guard let currentFileID = workspace.window.navigatorPane.file.current else { throw OperationError.MissingCurrentFile }

            let currentFileTreeVersion = workspace.files.version
            return driver.dispatch(Action.Workspace(workspaceID, WorkspaceAction.File(FileAction.CreateFolder(container: currentFileID, index: 0))))
                .continueOnSuccessWith(Executor.MainThread, continuation: { [driver] () throws -> FileID2 in
                    // Expects a new node.
                    // Anyway, new node may not be be created for any reason, and
                    // just throw an error in that case.

                    // Find a new node in journal.
                    guard let insertLog = driver.state.workspaces[workspaceID]?.files.journal.logs
                        .reverse()
                        .filter({ ($0.operation.isInsert) && ($0.version == currentFileTreeVersion) })
                        .first else {
                            throw OperationError.File(FileOperationError.CannotFindNewlyCreatedFolderID)
                        }
                    // Pick the inserted file.
                    switch insertLog.operation {
                    case .Insert(let newFolderID):
                        return newFolderID
                    default:
                        throw OperationError.File(FileOperationError.CannotFindNewlyCreatedFolderID)
                    }
                }).continueOnSuccessWith(Executor.MainThread, continuation: { [driver] (newFolderID: FileID2) -> () in
                    driver.dispatch(Action.Workspace(workspaceID, WorkspaceAction.File(FileAction.StartEditing(newFolderID))))
                })

//        case .FileNewFolder:
//            guard state.currentWorkspace != nil else { throw MainMenuActionError.MissingCurrentWorkspace }
//            try state.currentWorkspace?.appendNewFolderOnCurrentFolder()
//
//        case .FileNewFile:
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
}