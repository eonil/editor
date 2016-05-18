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
    /// Returns a task which completes *eventually*
    /// after the transaction has been processed completely.
    /// - State is fully updated
    /// - Rendering is done.
    /// Calling of the completion is done in main thread,
    /// and will be guarantted to happend in order as it
    /// passed-in.
    func dispatch(transaction: Transaction) -> Task<()> {
        return Driver.theDriver.dispatch(transaction)
    }
    /// Runs a command.
    ///
    /// - Returns:
    ///     A task which completes when the operation 
    ///     completes which has been triggered by this
    ///     command.
    func dispatch(command: Command) -> Task<()> {
        do {
            return try Driver.theDriver.operation.run(command).continueWithTask(continuation: { (task: Task<()>) -> Task<()> in
                if task.faulted {
                    Driver.theDriver.shell.alert(task.error ?? NSError(domain: "", code: -1, userInfo: [:])) // TODO: Configure error parameters properly.
                }
                return task
            })
        }
        catch let error {
            Driver.theDriver.shell.alert(error ?? NSError(domain: "", code: -1, userInfo: [:])) // TODO: Configure error parameters properly.
            return Task(error: error)
        }
    }
}
protocol DriverAccessible: Dispatchable {
}
extension DriverAccessible {
//    var operation: Operation {
//        get { return Driver.theDriver.operation }
//    }
    /// Currently processing transaction.
    /// Can be `nil` if you access this property out of
    /// transaction processing.
    var transaction: Transaction? {
        get { return Driver.theDriver.context }
    }
    /// Current app state.
    /// Driver guarantees no change in state while 
    /// processing an transaction.
    var state: State {
        get { return Driver.theDriver.state }
    }

}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct Schedule {
    var transaction: Transaction
    var completion: TaskCompletionSource<()>
}
private final class Driver {

    private static let theDriver = Driver()

    private var schedules = [Schedule]()
    private var context: Transaction?
    private var state = State()
    private let shell = Shell()
    private let operation = Operation()

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

    func dispatch(transaction: Transaction) -> Task<()> {
        assertMainThread()
        let schedule = Schedule(transaction: transaction, completion: TaskCompletionSource())
        schedules.append(schedule)
        return schedule.completion.task
    }
    func ADHOC_dispatchFromNonMainThread(transaction: Transaction) {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.dispatch(transaction)
        }
    }
    func run() {
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
    func step(schedule: Schedule) {
        assertMainThread()
        context = schedule.transaction
        do {
            try state.apply(schedule.transaction)
            schedule.completion.trySetResult(())
        }
        catch let error {
            shell.alert(error)
            schedule.completion.trySetError(error)
//            assert(false, "Error in stepping: \(error). This is only for information purpose, and you can safely ignore this assertion.")
//            fatalError("\(error)") // No way to recover in this case...
        }
        context = nil
        debugPrint("Applied transaction: \(schedule.transaction)")
    }
}

























