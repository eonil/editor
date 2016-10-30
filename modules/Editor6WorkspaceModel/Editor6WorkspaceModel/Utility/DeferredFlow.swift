////
////  DeferredFlow.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/22.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//
///// Manages signaling to deferred continuations.
/////
///// There are two big issues on interacting between model
///// and view. 
///// 
///// - State consistency.
///// - Re-enterring.
/////
///// It's impossible to guarantee these characteristics only
///// with dynamic checks. But I try to avoid as much as possible.
/////
///// There already are solutions.
/////
///// - Separate mutation and event notification phases completely
/////   and do not do them at once. Mutation first, and collect all
/////   notifications and notify later.
///// 
///// To do this, we need to **defer** mutations and notifications
///// to spcific time points, and this class help to do safely.
/////
///// First, you always start with `spawnMutationFlow()` call.
///// And code mutation in stepping of returned flow.
///// Stepping will produce notification-flow, and return it
///// to client. Client can continue from the notification flow,
///// and it's a safe timing which can provide consistent state
///// overall whole model.
/////
///// * spawn mutation flow
///// |
///// * perform mutation
///// |
///// * spawn notification flow
///// |
///// * return it
/////
///// - Note:
/////     A new deferred mutations can be spawned while signaling notifications.
/////     A new deferred notifications can be spawned while signaling mutations.
/////
///// - Note:
/////     All continuations are stored in function form, so it call-stack can
/////     potentially be tracked by LLDB.
/////
//internal final class DeferredFlowOrigin {
//    private let threadCheck = ThreadChecker()
//    private var deferredMutations = [() throws -> ()]()
//    private var deferredNotifications = [() throws -> ()]()
//    internal init() {}
//    internal func signalMutationsTiming() {
//        var cs = [() -> ()]()
//        swap(&cs, &deferredMutations)
//        for c in cs {
//            c()
//        }
//    }
//    internal func signalNotificationTiming() {
//        var cs = [() -> ()]()
//        swap(&cs, &deferredNotifications)
//        for c in cs {
//            c()
//        }
//    }
//    internal func mutate<Result>(_ f: @escaping () throws -> Result) -> DeferredNotificationFlow<Result> {
//
//    }
//    internal func spawnMutationFlow() -> DeferredMutationFlow {
//        threadCheck.assertSameThread()
//        let f = DeferredMutationFlow(origin: self)
//        let s = { [f] in f.signalToMutate() }
//        deferredMutations.append(s)
//        return f
//    }
//    internal func spawnNotificationFlow<Result>() -> DeferredNotificationFlow<Result> {
//        threadCheck.assertSameThread()
//        let f = DeferredNotificationFlow<Result>(origin: self)
//        let s = { [f] in f.signalToContinue() }
//        deferredNotifications.append(s)
//        return f
//    }
//}
//
//internal final class DeferredMutationFlow {
//    private let origin: DeferredFlowOrigin
//    private var steps: [() throws -> ()] = []
//    internal init(origin: DeferredFlowOrigin) {
//        self.origin = origin
//    }
//    func signalToMutate() {
//        var ss = [() -> ()]()
//        swap(&ss, &steps)
//        for s in ss {
//            s()
//        }
//    }
//    /// - Parameter f:
//    ///     Will be called asynchronously on near future at the beginning of driver loop.
//    func mutate<Result>(_ f: @escaping () throws -> (Result)) -> DeferredNotificationFlow<Result>  {
//        let cf: DeferredNotificationFlow<Result> = origin.spawnNotificationFlow()
//        steps.append {
//            let r = try f()
//            cf.setResult(r)
//        }
//        return cf
//    }
//}
//
//public final class DeferredNotificationFlow<Result> {
//    private let threadCheck = ThreadChecker()
//    private var result = Result?.none
//    private let origin: DeferredFlowOrigin
//    private var steps: [() -> ()] = []
//    internal init(origin: DeferredFlowOrigin) {
//        threadCheck.assertSameThread()
//        self.origin = origin
//    }
//    /// Adds continuation function that will be executed 
//    /// after all mutations done, so overall states are
//    /// fully consistent.
//    public func step(_ f: @escaping (Result) -> ()) {
//        threadCheck.assertSameThread()
//        // Holds `self` until notification finishes.
//        steps.append { [s = self] in
//            guard let r = s.result else { reportError("Result not yet been resolved.") }
//            f(r)
//        }
//    }
//
//    fileprivate func setResult(_ newResult: Result) {
//        threadCheck.assertSameThread()
//        result = newResult
//    }
//    fileprivate func signalToContinue() {
//        threadCheck.assertSameThread()
//        assert(result != nil)
//        var ss = [() -> ()]()
//        swap(&ss, &steps)
//        for s in ss {
//            s()
//        }
//    }
//}
//
//fileprivate func reportError(_ message: String) -> Never {
//    fatalError(message)
//}
