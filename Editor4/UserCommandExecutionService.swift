////
////  UserOperationService.swift
////  Editor4
////
////  Created by Hoon H. on 2016/05/15.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import BoltsSwift
//
///// Executes user-commands. (which means terminal commands)
/////
///// "Terminal commands" means the command doesn't need to bo continued,
///// so doesn't need to return any value. In this case, all commands can
///// be declared with only pure values.
/////
//final class UserCommandExecutionService: DriverAccessible {
//    /// **NOT IMPLEMENTED YET!!!**
//    /// Abstracts user file name editing operation.
//    ///
//    /// 1. This becomes non-nil value when user starts editing of a file name
//    ///     in file navigator.
//    /// 2. The task completes when user commits changes.
//    /// 3. Any error or cancellation would produce faulted/cancelled task respectively.
//    /// 4. This task becomes nil when user finishes editing operaiton regardless of
//    ///     result status. After setting task result.
//    ///
//    private var EXPERIMENTAL_editingFileName: TaskCompletionSource<()>?
//
//    /// **NOT IMPLEMENTED YET!!!**
//    /// Abstracts create-new-folder operation.
//    /// 1. Creates a new node.
//    /// 2. Start editing of the node.
//    /// 3. Accepts user input.
//    /// 4. User finishes editing. Results to a file-ID if succeeded.
//    ///
//    private var EXPERIMENTAL_createNewFolder: TaskCompletionSource<FileID2>?
//
////    /// Runs a command.
////    ///
////    /// - Returns:
////    ///     A task which completes when the operation
////    ///     completes which has been triggered by this
////    ///     command.
////    func dispatch(command: UserCommand) -> Task<()> {
////        return driver.userInteraction.query().continueWithTask { [driver, weak self] task in
////            guard let S = self else { return Task.cancelledTask() }
////            guard let state = task.result else { return Task.cancelledTask() }
////            do {
////                return try S.run(state: state, command: command).continueWithTask(continuation: { [weak self] (task: Task<()>) -> Task<()> in
////                    if task.faulted {
////                        guard let error = task.error else { fatalError("`Task.faulted == true` with no error object.") }
////                        self?.driver.userInteraction.dispatch(UserAction.Shell(ShellAction.Alert(error)))
////                        reportErrorToDevelopers(error)
////                    }
////                    return task
////                })
////            }
////            catch let error {
////                reportErrorToDevelopers(error)
////                driver.userInteraction.dispatch(UserAction.Shell(ShellAction.Alert(error)))
////                return Task(error: error)
////            }
////        }
////    }
//}
//
//enum UserOperationError: ErrorType {
////    case CannotRunTheCommandInCurrnetState
//    case MissingCurrentWorkspace
//    case MissingCurrentWorkspaceLocation
//    case MissingCurrentFile
//    case NoSelectedFile
//    case File(FileUserOperationError)
//    case BadFileURL
//    case MissingWorkspace(WorkspaceID)
//    case CannotResolvePathForWorkspaceFile((WorkspaceID, FileID2))
//    case CannotMakeNewURL(oldURL: NSURL, newName: String)
//    case cannotResolveExecutableURLFor(WorkspaceID)
//}
//enum FileUserOperationError {
//    case CannotMakeNameForNewFolder
//    case CannotFindNewlyCreatedFolderID
//    case BadPath(FileNodePath)
//}
//
//extension UserCommandExecutionService {
//    /// Runs a long-running command.
//    /// This method is also responsible to determine executability of the command.
//    /// This is also responsible for concurrency management. Some command can be
//    /// executed if they can be executed concurrently.
//    ///
//    /// Whatever you run, running status must be dispatched to `State` using `dispatch(Action)`
//    /// to be rendered to user.
//    ///
//    private func run(state state: UserInteractionState, command: UserCommand) throws -> Task<()> {
//        assertMainThread()
//        switch command {
//        case .UserInteraction(let command):
//            return try run(state: state, command: command)
//
//        case .closeWorkspace(let workspaceID):
//            return driver.operation.closeWorkspace(workspaceID)
//        }
//    }
//}
//
//extension UserCommandExecutionService {
//    private func run(state state: UserInteractionState, command: UserInteractionCommand) throws -> Task<()> {
//        assertMainThread()
//        let driver = self.driver
//        switch command {
//        case .Rename(let workspaceID, let fileID, let newName):
//            return driver.operation.workspace(workspaceID, file: fileID, renameTo: newName)
//        }
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
