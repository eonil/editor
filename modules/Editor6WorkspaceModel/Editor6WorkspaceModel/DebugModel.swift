////
////  DebugModel.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/17.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import LLDBWrapper
//
//public enum DebugNotification {
//    case queue(ModelContinuation)
//    case apply(ModelTransaction<DebugState>)
//}
//public enum DebugError: Error {
//    case unknown(Error)
//    case missingSelf
//    case badTargetID(DebugTargetID)
//    case missingTarget(for: DebugTargetID)
//    case badProcessID(DebugProcessID)
//    case badThreadID(DebugThreadID)
//    case cannotLaunch
//    case message(String)
//    init(_ message: String) {
//        self = .message(message)
//    }
//}
//fileprivate typealias DebugDelegate = (DebugNotification) -> ()
//
//public final class DebugModel {
//    private let lldb = LLDBDebugger()!
//    private var delegate = ((DebugNotification) -> ())?.none
//    private var local = LocalState()
//
//    func delegate(to newDelegate: @escaping (DebugNotification) -> ()) {
//        delegate = newDelegate
//    }
//    fileprivate typealias NoteMutation = (DebugMutation) -> ()
//    fileprivate typealias Perform<T> = (_ local: inout LocalState, _ note: NoteMutation) throws -> (T)
//    fileprivate func queueSingleStepMutation<T>(_ f: @escaping Perform<T>) -> Future<T> {
//        let f1 = Future<T>()
//        let queueSignaling = { [weak self] (signal: Result<T>) in
//            guard let s = self else { return }
//            s.delegate?(.queue({ f1.signal(signal) }))
//        }
//
//        // 1. Queue initiation.
//        delegate?(.queue({ [weak self] in
//            guard let s = self else {
//                f1.signal(.error(DebugError.missingSelf))
//                return
//            }
//            do {
//                // 2. Any mutation will be sent to delegate.
//                let r = try s.mutate(f)
//                // 3. Queue completion.
//                queueSignaling(.ok(r))
//            }
//            catch let error as DebugError { queueSignaling(.error(error)) }
//            catch let error { queueSignaling(.error(error)) }
//        }))
//        return f1
//    }
//    private func mutate<T>(_ f: Perform<T>) throws -> (T) {
//        let old = local.debugState
//        var by = [DebugMutation]()
//        defer {
//            let new = local.debugState
//            let t = ModelTransaction<DebugState>(from: old, to: new, by: by)
//            delegate?(.apply(t))
//        }
//        return try f(&local, { by.append($0) })
//    }
//}
//
//public extension DebugModel {
//    public func reload() -> Future<DebugState> {
//        return queueSingleStepMutation { local, _ in
//            return local.debugState
//        }
//    }
//    public func addTarget(executable: URL) -> Future<DebugTargetID> {
//        return queueSingleStepMutation { local, note in
//            let newTargetID = DebugTargetID()
//            guard let newLLDBTarget = local.lldb.createTarget(withFilename: executable.path, andArchname: LLDBArchDefault64Bit) else {
//                throw DebugError.cannotLaunch
//            }
//            let newTargetState = newLLDBTarget.toModelState(with: newTargetID)
//            local.targetMapping[newTargetID] = newLLDBTarget
//            local.debugState.targets[newTargetID] = newTargetState
//            note(.targets(local.debugState.targets))
//            return newTargetID
//        }
//    }
//    /// Also kills process if one is running for the target.
//    public func removeTarget(targetID: DebugTargetID) -> Future<()> {
//        return queueSingleStepMutation { local, note in
//            guard local.debugState.targets[targetID] != nil else { throw DebugError.missingTarget(for: targetID) }
//            guard let lldbTarget = local.targetMapping[targetID] else { throw DebugError.badTargetID(targetID) }
//            _ = lldbTarget.process?.kill()
//            local.lldb.delete(lldbTarget)
//            local.targetMapping[targetID] = nil
//            local.debugState.targets[targetID] = nil
//            note(.targets(local.debugState.targets))
//        }
//    }
//
//    /// - Returns:
//    ///     A step WILL contain running processID on success.
//    ///     This step is executed after local state update has been completed
//    ///     and related notification has been sent to delegate.
//    public func launch(targetID: DebugTargetID) -> Future<DebugProcessID> {
//        return queueSingleStepMutation { local, note in
//            guard let lldbTarget = local.targetMapping[targetID] else { throw DebugError.badTargetID(targetID) }
//            guard let lldbProcess = lldbTarget.launchProcessSimply(withWorkingDirectory: "Failed to launch process.") else { throw DebugError.badTargetID(targetID) }
//            guard local.debugState.targets[targetID] != nil else { throw DebugError.badTargetID(targetID) }
//            let newProcessID = DebugProcessID(ownerTargetID: targetID, rawValue: lldbProcess.processID)
//            let newProcessState = DebugProcessState()
//            local.processMapping[newProcessID] = lldbProcess
//            local.debugState.processes[newProcessID] = newProcessState
//            local.debugState.targets[targetID]?.processID = newProcessID
//            note(.processes(local.debugState.processes))
//            note(.targets(local.debugState.targets))
//            return newProcessID
//        }
//    }
//    public func kill(processID: DebugProcessID) -> Future<()> {
//        return queueSingleStepMutation { local, note in
//            guard let lldbProcess = local.processMapping[processID] else { throw DebugError.badProcessID(processID) }
//            lldbProcess.kill()
//            local.debugState.processes[processID] = nil
//            local.processMapping[processID] = nil
//            local.debugState.targets[processID.ownerTargetID]?.processID = nil
//            note(.processes(local.debugState.processes))
//            note(.targets(local.debugState.targets))
//        }
//    }
//
//    public func stop(processID: DebugProcessID) -> Future<()> {
//        return queueSingleStepMutation { local, note in
//            guard let lldbProcess = local.processMapping[processID] else { throw DebugError.badProcessID(processID) }
//            lldbProcess.stop()
//            note(.processes(local.debugState.processes))
//        }
//    }
//    public func `continue`(processID: DebugProcessID) -> Future<()> {
//        return queueSingleStepMutation { local, note in
//            guard let lldbProcess = local.processMapping[processID] else { throw DebugError.badProcessID(processID) }
//            lldbProcess.continue()
//            note(.processes(local.debugState.processes))
//        }
//    }
//    public func reloadVariables(targetID: DebugTargetID,
//                              processID: DebugProcessID,
//                              threadID: DebugThreadID,
//                              frameIndex: UInt32,
//                              varialbePath: [String]) -> Future<[DebugVariable]> {
//        precondition(varialbePath == [], "Feature unsupported yet...")
//        return queueSingleStepMutation { local, note in
//            guard let lldbTarget = local.targetMapping[targetID] else { throw DebugError.badTargetID(targetID) }
//            guard let lldbProcess = lldbTarget.launchProcessSimply(withWorkingDirectory: "") else { throw DebugError.badTargetID(targetID) }
//            guard let lldbThread = lldbProcess.allThreads.filter({ $0.threadID == threadID.rawValue }).first else { throw DebugError.badThreadID(threadID) }
//            let lldbFrame = lldbThread.frame(at: frameIndex)
//            let lldbVars = lldbFrame?.variables(withArguments: true, locals: true, statics: true, inScopeOnly: true, useDynamic: LLDBDynamicValueType.dynamicCanRunTarget)
//            let newVariables = (lldbVars?.allValues ?? []).flatMap({$0?.toModel()})
//            local.debugState.variables = newVariables
//            note(.variables(newVariables))
//            return newVariables
//        }
//    }
//}
//
//fileprivate struct LocalState {
//    let lldb = LLDBDebugger()!
//    var delegate = ((DebugNotification) -> ())?.none
//    var debugState = DebugState()
//    var targetMapping = [DebugTargetID: LLDBTarget]()
//    var processMapping = [DebugProcessID: LLDBProcess]()
//}
//
//fileprivate extension LLDBTarget {
//    func toModelState(with targetID: DebugTargetID) -> DebugTargetState {
//        let pid = { () -> DebugProcessID? in
//            if let rawPID = process?.processID { return DebugProcessID(ownerTargetID: targetID, rawValue: rawPID) }
//            return nil
//        }()
//        return DebugTargetState(processID: pid)
//    }
//}
//
//fileprivate extension LLDBProcess {
//    func toModelState() -> DebugProcessState {
//        return DebugProcessState(
//            threads: allThreads.map({ $0.toModelState() })
//        )
//    }
//}
//
//fileprivate extension LLDBThread {
//    func toModelState() -> DebugThread {
//        let id = DebugThreadID(rawValue: threadID)
//        let state = DebugThreadState(
//            frames: allFrames.flatMap({ $0?.toModelState() }))
//        return (id,state)
//    }
//}
//
//fileprivate extension LLDBFrame {
//    func toModelState() -> DebugFrame {
//        let id = frameID
//        let state = DebugFrameState(
//            functionName: functionName ?? nil)
//        return (id,state)
//    }
//}
//
//fileprivate extension LLDBValue {
//    func toModel() -> DebugVariable {
//        return DebugVariable(
//            name: valueExpression,
//            value: (),
//            expression: valueExpression)
//    }
//}
