////
////  Model.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/22.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import EonilToolbox
//
//
//
//
//public struct WorkspaceID: Hashable {
//    fileprivate var oid = ObjectAddressID()
//    public var hashValue: Int { return oid.hashValue }
//}
//public func == (_ a: WorkspaceID, _ b: WorkspaceID) -> Bool {
//    return a.oid == b.oid
//}
//
//public struct DebugID: Hashable {
//    var ownerWorkspaceID: WorkspaceID
//    public var hashValue: Int { return ownerWorkspaceID.hashValue }
//}
//public func == (_ a: DebugID, _ b: DebugID) -> Bool {
//    return a.ownerWorkspaceID == b.ownerWorkspaceID
//}
//
//
//public enum ModelMutation {
//    case workspace(WorkspaceMutation)
//}
//public enum WorkspaceMutation {
//    case debug(DebugMutation)
//}
//
//
//
//
//public enum Model2Action {
//    case mutate(ModelMutation)
//    case initiate(ModelContinuation)
//    case complete(ModelContinuation)
//}
//final class Model {
//    private var delegate = ((DebugNotification) -> ())?.none
//    private var local = LocalState()
//
//    func delegate(to newDelegate: @escaping (DebugNotification) -> ()) {
//        delegate = newDelegate
//    }
//    fileprivate func queueSingleStepMutation<T>(_ f: @escaping (inout LocalState) throws -> (T)) -> Future<T,DebugError> {
//        let f1 = Future<T,DebugError>()
//        delegate?(.queue({ [weak self] in
//            guard let s = self else {
//                f1.signal(.error(.missingSelf))
//                return
//            }
//
//            do {
//                let r = try s.mutate(f)
//                s.delegate?(.change(s.local.debugState))
//                f1.signal(.ok(r))
//            }
//            catch let error as DebugError { f1.signal(.error(error)) }
//            catch let error { f1.signal(.error(.unknown(error))) }
//        }))
//        return f1
//    }
//    private func mutate<T>(_ f: (inout LocalState) throws -> (T)) throws -> (T) {
//        return try f(&local)
//    }
//}
//
//fileprivate struct Local {
//    var workspaceMapping = [WorkspaceID: WorkspaceModel]()
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
//extension Model {
//    static func subscribe(debug: DebugID, handler: (DebugNotification) -> ()) {
//        
//    }
//}
//
//
////public enum ModelError: Error {
////
////}
////public enum Model {
////    public enum Workspace {
////        public enum Debug {}
////    }
////}
////
////public extension Model {
////
////}
////
////public extension Model.Workspace.Debug {
////    public static func launch() -> Future<DebugProcessID,ModelError> {
////
////    }
////}
////
//
//
//
//
//
////
////fileprivate struct ModelState {
////    var workspaces = [WorkspaceModel]()
////}
////
////public final class Model {
////    internal let deferredFlowOrigin = DeferredFlowOrigin()
////    private let stateContainer: DeferableStateContainer<ModelState>
////
////    public init() {
////        stateContainer = DeferableStateContainer(origin: deferredFlowOrigin, state: ModelState())
////    }
////
////    public func signalMutationTiming() {
////        deferredFlowOrigin.signalMutationsTiming()
////    }
////    public func signalNotificationTiming() {
////        deferredFlowOrigin.signalNotificationTiming()
////    }
////
////    func addWorkspace() -> DeferredNotificationFlow<WorkspaceModel> {
////        return stateContainer.queueDeferredMutation { (s: ModelState) -> (ModelState, WorkspaceModel) in
////            var s1 = s
////            let m = WorkspaceModel()
////            s1.workspaces.append(m)
////            return (s1, m)
////        }
////    }
////    func removeWorkspace(workspace: WorkspaceModel) -> DeferredNotificationFlow<()> {
////        return stateContainer.queueDeferredMutation { (s: ModelState) -> (ModelState, ()) in
////            var s1 = s
////            s1.workspaces.remove(workspace)
////            return (s1, ())
////        }
////    }
////}
