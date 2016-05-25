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
}

/// User-interaction service is special because;
///
/// - it has to run in main thread only
/// - provide quick response with smallest latency.
///
/// To archive this goal, user-interaction service exposes its state 
/// publicly so it can be accessed from anywhere in main thread.
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

    /// Returns a task which completes *eventually*
    /// after the action has been processed completely.
    /// - State is fully updated
    /// - Rendering is done.
    /// Calling of the completion is done in main thread,
    /// and will be guarantted to happend in order as it
    /// passed-in.
    func dispatch(action: Action) -> Task<()> {
        assertMainThread()
        let schedule = Schedule(action: action, completion: TaskCompletionSource())
        schedules.append(schedule)
        return schedule.completion.task
    }

    func ADHOC_dispatchFromNonMainThread(action: Action) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.dispatch(action)
        }
    }

    private func run() {
        assertMainThread()
        if schedules.isEmpty == false {
            JournalingClearanceChecker.resetClearanceOfAllCheckers()
            while let s = schedules.popFirst() {
                step(s)
            }
            shell.render()
            state.clearJournals()
            JournalingClearanceChecker.checkClearanceOfAllCheckers()
        }
    }
    private func step(schedule: Schedule) {
        assertMainThread()
        do {
            try state.apply(schedule.action)
            schedule.completion.trySetResult(())
        }
        catch let error {
            shell.alert(error)
            schedule.completion.trySetError(error)
            //            assert(false, "Error in stepping: \(error). This is only for information purpose, and you can safely ignore this assertion.")
            //            fatalError("\(error)") // No way to recover in this case...
        }
        debugPrint("Applied action: \(schedule.action)")
    }
}

private struct Schedule {
    var action: Action
    var completion: TaskCompletionSource<()>
}































