////
////  Model2.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/30.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//
//public struct Model2State {
//
//}
//
//public enum Model2Error: Error {
//
//}
//
//public final class Model2 {
//    private var delegate = ((Model2Action) -> ())?.none
//    private var local = Local()
//    public init() {}
//    public func delegate(to newDelegate: @escaping (Model2Action) -> ()) {
//        assert(delegate == nil, "You can set delegate only once.")
//        delegate = newDelegate
//    }
//    fileprivate func queueSingleStepMutation<T>(_ f: @escaping (inout Local) throws -> (T)) -> Future<T,DebugError> {
//        let f1 = Future<T,DebugError>()
//        delegate?(.initiation({ [weak self] in
//            guard let s = self else {
//                f1.signal(.error(.missingSelf))
//                return
//            }
//
//            do {
//                let r = try s.mutate(f)
//                s.delegate?(.completion({ f1.signal(.ok(r)) }))
//            }
//            catch let error as DebugError { f1.signal(.error(error)) }
//            catch let error { f1.signal(.error(.unknown(error))) }
//        }))
//        return f1
//    }
//    private func mutate<T>(_ f: (inout Local) throws -> (T)) throws -> (T) {
//        return try f(&local)
//    }
//}
//public extension Model2 {
//    public func addWorkspace() -> Future<WorkspaceModel, Model2Error> {
//        return queueSingleStepMutation { local in
//
//        }
//    }
//    public func removeWorkspace() -> Future<WorkspaceModel, Model2Error> {
//
//    }
//}
//public enum Model2Action {
//    case initiation(ModelContinuation)
////    case mutation(ModelContinuation)
//    case completion(ModelContinuation)
////    /// Enqueues a continuation at last.
////    /// Completion continuation for an operation
////    /// MUST use this action.
////    case queueLast(ModelContinuation)
////    /// Enqueues a continuation at first.
////    /// State mutation notification 
////    /// MUST use this action to ensure them to be
////    /// executed before starting any other 
////    /// operations.
////    case queueFirst(ModelContinuation)
//}
//
////struct Model2Transaction {
////    var from: Model2State
////    var to: Model2State
////    var by: Model2Mutation
////}
//
//
//enum Model2Mutation {
//    case debug(DebugMutation)
//}
//
//fileprivate struct Local {
//    var state = WorkspaceState()
//}
