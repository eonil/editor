//
//  Driver.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import BoltsSwift
import EonilToolbox

protocol Dispatchable {
}
extension Dispatchable {
}
protocol DriverAccessible: Dispatchable {
}
extension DriverAccessible {
    var driver: Driver {
        get { return Driver.theDriver }
    }
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct Schedule {
    var action: Action
    var completion: TaskCompletionSource<()>
}
final class Driver {

    private static let theDriver = Driver()

    private var schedules = [Schedule]()
    private var context: Action?
    private(set) var state = State()
    private let shell = Shell()
    private let operation = OperationService()
    let query = QueryFlowService()

    private init() {
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

    /// Runs a command.
    ///
    /// - Returns:
    ///     A task which completes when the operation
    ///     completes which has been triggered by this
    ///     command.
    func run(command: Command) -> Task<()> {
        do {
            return try operation.run(command).continueWithTask(continuation: { [weak self] (task: Task<()>) -> Task<()> in
                if task.faulted {
                    self?.shell.alert(task.error ?? NSError(domain: "", code: -1, userInfo: [:])) // TODO: Configure error parameters properly.
                }
                return task
            })
        }
        catch let error {
            shell.alert(error ?? NSError(domain: "", code: -1, userInfo: [:])) // TODO: Configure error parameters properly.
            return Task(error: error)
        }
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
            shell.render(state)
            state.clearJournals()
            JournalingClearanceChecker.checkClearanceOfAllCheckers()
        }
    }
    private func step(schedule: Schedule) {
        assertMainThread()
        context = schedule.action
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
        context = nil
        debugPrint("Applied action: \(schedule.action)")
    }
}

























