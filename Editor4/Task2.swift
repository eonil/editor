////
////  Task2.swift
////  Editor4
////
////  Created by Hoon H. on 2016/05/22.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Dispatch
////struct Continuation {
////    func continue
////}
//
//enum Task2State<Result> {
//    case Running
//    case Cancel
//    case Error(ErrorType)
//    case Complete(Result)
//}
//final class Task2Controller<Result> {
//    func cancel() {
//
//    }
//    func setError(error: ErrorType) {
//
//    }
//    func setResult(result: Result) {
//
//    }
//}
//final class Task2<Result> {
//    private var stateContainer: Task2StateContainer<Result>?
//
//    private init(stateContainer: Task2StateContainer<Result>) {
//        self.stateContainer = stateContainer
//    }
//    private init(_ state: Task2State<Result>) {
//        stateContainer = Task2StateContainer(state)
//    }
//    convenience init(error: ErrorType) {
//        self.init(Task2State.Error(error))
//    }
//    convenience init(result: Result) {
//        self.init(Task2State.Complete(result))
//    }
//    private func continueInQueue<ContinuationResult>(queue: dispatch_queue_t, continuation: Task2State<Result> -> Task2State<Result>) -> Task2 {
//        guard let context = stateContainer else { fatalError("This task already been continued from somewhere else.") }
//        // At this point, current task becomes invalidated, and cannot continue anymore.
//        stateContainer = nil
//        let newTask = Task2(stateContainer: context)
//        dispatch_async(queue) {
//            context.state = continuation(context.state)
//        }
//        return newTask
//    }
//}
//private final class Task2StateContainer<Result>: NonObjectiveCBase {
//    var state: Task2State<Result>
//    init(_ state: Task2State<Result>) {
//        self.state = state
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
//
//
//
//
//
//
//
