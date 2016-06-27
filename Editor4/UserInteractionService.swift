//
//  UserInteractionService.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/21.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Dispatch
import BoltsSwift
import EonilToolbox

typealias UserInteractionState = State

enum UserInteractionError: ErrorType {
    case MissingResult
    case ResultTypeMismatch

    case MissingCurrentFile
    case UnknownFiles([FileID2])

    case CannotRenameFileBecauseNewNameIsEqualToOldName
    case CannotRenameFileBecauseSameNameAlreadyExists
}

/// User-interaction service is special because;
///
/// - it has to run in main thread only
/// - provide quick response with smallest latency.
///
/// To archive this goal, user-interaction service exposes its state 
/// publicly so it can be accessed from anywhere in main thread.
///
/// - Note:
///     There's no way to dispatch a transaction aynchronously.
///     This is intentional design choice.
///
final class UserInteractionService {
    private(set) var state = UserInteractionState()
    private var schedules = [Schedule]()
    private let shell = Shell()

    init() {
        do {
            try DisplayLinkUtility.installMainScreenHandler(ObjectIdentifier(self)) { [weak self] in
                dispatch_async(dispatch_get_main_queue()) { [weak self] in
                    self?.run()
                }
            }
        }
        catch let error {
            fatalError("\(error)") // No way to recover in this case...
        }
    }
    deinit {
        DisplayLinkUtility.deinstallMainScreenHandler(ObjectIdentifier(self))
    }

    /// - Returns:
    ///     A task which provide a copy of latest user-interaction state.
    ///     If will run in main thread (UI thread) if you continue from the returning task.
    ///     Take care.
    ///     
    /// - Note: 
    ///     I am considering aligning completion timing of returing task to v-sync timing.
    ///
    func query() -> Task<UserInteractionState> {
        return Task(()).continueWithTask(Executor.MainThread) { [state] _ in
            return Task(state)
        }
    }

    /// Scans user-interaction state from AppKit scene-graph immediately.
    func ADHOC_scanImmediately() {
        shell.scan()
    }

    /// Returns a task which completes *eventually*
    /// after the action has been processed completely.
    /// - State is fully updated
    /// - Rendering is done.
    /// Calling of the completion is done in main thread,
    /// and will be guarantted to happend in order as it
    /// passed-in.
    func dispatch(action: UserAction) -> Task<()> {
        return dispatch { (state: UserInteractionState) throws -> (UserInteractionState) in
            var copy = state
            try copy.apply(action)
            debugPrint("Applied action: \(action)")
            return copy
        }
    }

    func ADHOC_dispatchRenderingInvalidation() {
        dispatch({ $0 })
    }

    func dispatch(transaction: ((UserInteractionState) throws -> (UserInteractionState))) -> Task<()> {
        let schedule = Schedule(transaction: transaction, completion: TaskCompletionSource())
        // TODO: Review this design... It would be better if we can eliminte
        //          asynchronous dispatch for dispatch from main thread.
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let S = self else { return }
            assertMainThread()
            S.schedules.append(schedule)
        }
        return schedule.completion.task
    }
    func dispatch(transaction: ((inout UserInteractionState) throws -> ())) -> Task<()> {
        return dispatch({ (state: UserInteractionState) throws -> (UserInteractionState) in
            var state1 = state
            try transaction(&state1)
            return state1
        })
    }
    private func run() {
        assertMainThread()
        if schedules.isEmpty == false {
            JournalingClearanceChecker.resetClearanceOfAllCheckers()
            while let s = schedules.popFirst() {
                step(s)
            }
            shell.render(state)
            state.clearJournals()
            JournalingClearanceChecker.checkClearanceOfAllCheckers()
        }
    }
    private func step(schedule: Schedule) {
        assertMainThread()
        do {
            state = try schedule.transaction(state)
            state.assertConsistency()
            schedule.completion.trySetResult(())
        }
        catch let error {
            debugLog(error)
            shell.alert(error)
            schedule.completion.trySetError(error)
        }
    }
}

private typealias UserInteractionStateTransaction = UserInteractionState throws -> UserInteractionState
private struct Schedule {
    var transaction: UserInteractionStateTransaction
    var completion: TaskCompletionSource<()>
}
































