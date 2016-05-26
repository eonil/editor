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

protocol DriverAccessible {
}
extension DriverAccessible {
    var driver: Driver {
        get { return Driver.theDriver }
    }
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

final class Driver {
    private static let theDriver = Driver()
    private let user = UserInteractionService()
    private let operation = UserOperationService()
    private let platform = PlatformService()
    private let query = QueryService()

    private init() {
    }
    var userInteractionState: UserInteractionState {
        get { return user.state }
    }
    func ADHOC_scanImmediately() {
        user.ADHOC_scanImmediately()
    }
    func ADHOC_renderImmediately() {
        user.ADHOC_renderImmediately()
    }
    func dispatch(action: Action) -> Task<()> {
        return user.dispatch(action)
    }
    func run(command: UserOperationCommand) -> Task<()> {
        return operation.dispatch(command)
    }
    func run(command: PlatformCommand) -> Task<()> {
        return platform.dispatch(command)
    }
    func wait<T>(id: QueryID<T>) -> Task<T> {
        return query.wait(id) 
    }
    func dispatch<T>(value: T, to id: QueryID<T>) {
        query.dispatch(value, to: id)
    }
    func notify(notification: Notification) -> Task<()> {
        return user.dispatch(Action.Notify(notification))
    }
}
extension Driver {
//    /// `dispatch` and query the result.
//    /// Use this method only when you are sure that the action can return a value
//    /// in a certain type.
//    func dispatchQuery<T>(action: Action) -> Task<T> {
//        assertMainThread()
//        let queryID = QueryID<T>()
//        let queryTask = wait(queryID)
//        return dispatch(action).continueWithTask(continuation: { (task: Task<()>) -> Task<T> in
//            precondition(task.completed)
//            if let error = task.error { return Task(error: error) }
//            if task.cancelled { return Task.cancelledTask() }
//            // Query may continue a bit longer...
//            return queryTask
//        })
//    }
}





























