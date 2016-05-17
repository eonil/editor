//
//  Operations.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import BoltsSwift

/// Manages all long-running operations.
///
struct Operation: DriverAccessible {
    private let services = Services()
}
enum OperationError: ErrorType {
    case CannotRunTheCommandInCurrnetState
}

extension Operation {
    /// Runs a long-running command.
    /// This method is also responsible to determine executability of the command.
    /// This is also responsible for concurrency management. Some command can be
    /// executed if they can be executed concurrently.
    ///
    /// Whatever you run, running status must be dispatched to `State` using `dispatch(Transaction)`
    /// to be rendered to user.
    ///
    func run(command: Command) throws -> Task<()> {
        switch command {
        case .MainMenu(let command):
            return try run(command)
        }
    }
    private func run(command: MainMenuCommand) throws -> Task<()> {
        let dispatch = self.dispatch as (Transaction) -> Task<()>
        switch command {
        case .FileNewWorkspace:
            guard services.cargo.state.isRunning == false else { throw OperationError.CannotRunTheCommandInCurrnetState }
            var u1: NSURL?
            return DialogueUtility.runFolderSaveDialogue().continueOnSuccessWithTask(continuation: { [services] (u: NSURL) -> Task<()> in
                u1 = u
                return try services.cargo.run(.New(u))
            }).continueWithTask(continuation: { [services] (task: Task<()>) -> Task<()> in
                dispatch_async(dispatch_get_main_queue()) { [services] in
                    dispatch(.ApplyCargoServiceState(services.cargo.state))
                    let workspaceID = WorkspaceID()
                    dispatch(.Workspace(workspaceID, .Open))
                    dispatch(.Workspace(workspaceID, .Reconfigure(location: u1)))
                }
                return task
            })

//        case .FileNewFolder:
//            guard state.currentWorkspace != nil

//        case .FileNewFolder:
//            guard state.currentWorkspace != nil else { throw MainMenuTransactionError.MissingCurrentWorkspace }
//            try state.currentWorkspace?.appendNewFolderOnCurrentFolder()
//
//        case .FileNewFile:
//            guard state.currentWorkspace != nil else { throw MainMenuTransactionError.MissingCurrentWorkspace }
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
    //        guard let workspaceID = state.currentWorkspaceID else { throw MainMenuTransactionError.MissingCurrentWorkspace }
    //        try services.cargo.run(.Build).continueWith(.MainThread, continuation: { (task: Task<()>) -> () in
    //            services.dispatch(Transaction.Workspace(id: workspaceID, transaction: WorkspaceTransaction.UpdateBuildState))
    //        })
    //
    //    case .ProductClean:
    //        guard let workspaceID = state.currentWorkspaceID else { throw MainMenuTransactionError.MissingCurrentWorkspace }
    //        try services.cargo.run(.Clean).continueWith(.MainThread, continuation: { (task: Task<()>) -> () in
    //            services.dispatch(Transaction.Workspace(id: workspaceID, transaction: WorkspaceTransaction.UpdateBuildState))
    //        })

    //        case .ProductRun:
    //        case .ProductStop:

        default:
            MARK_unimplemented()
        }
    }
}