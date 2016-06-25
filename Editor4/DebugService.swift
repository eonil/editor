////
////  DebugService.swift
////  Editor4
////
////  Created by Hoon H. on 2016/06/02.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Dispatch
//import LLDBWrapper
//import BoltsSwift
//
//enum DebugCommand {
//    case AddTarget(DebugTargetID, executable: NSURL)
//    case RemoveTarget(DebugTargetID)
//    case LaunchTarget(DebugTargetID)
//    case HaltSession(DebugSessionID)
//}
//enum DebugError: ErrorType {
//    case BadParameter(Any, message: String)
//    case InconsistenctState(message: String)
//    case OperationFailure(message: String)
//    case MissingSession(DebugSessionID)
//}
//
////enum DebugNotification {
////    case Step(DebugState)
////    case StepThread(DebugThreadID, DebugThreadState)
////    case StepStackFrame(DebugCallStackFrameState)
////}
//
///// Manages debugging.
/////
///// This abstracts any underlying specific debugging service.
///// For now, I use LLDB via `LLDBService`.
///// This service keeps its own state internally, and UI need to query
///// debugging state from here.
///// This manages LLDB under the hood, and update and expose current 
///// debugging state.
/////
///// This is a service, so a separated actor. The state is hidden and
///// the only way to get the state is taking driver stepping notification.
/////
//final class DebugService {
//    private let gcdq = dispatch_queue_create("\(DebugService.self)/GCDQ", DISPATCH_QUEUE_SERIAL)
//    private let semaw = dispatch_semaphore_create(0)!
//    private var state = DebugState()
//    private let lldb = LLDBDebugger()
//    private let qchk: QueueChecker
//
//    private var targetMapping = [DebugTargetID: LLDBTarget]()
//
//    init() {
//        qchk = QueueChecker(gcdq)
//    }
//
//    /// Gets service state asynchonously.
//    ///
//    /// - Returns:
//    ///     A task which will be resolved into `DebugState`.
//    ///
//    func query() -> Task<DebugState> {
//        let completion = TaskCompletionSource<DebugState>()
//        dispatch_async(gcdq) { [weak self] in
//            guard let S = self else { return }
//            assert(completion.task.completed == false)
//            completion.trySetResult(S.state)
//        }
//        return completion.task
//    }
//    func queryAllThreadsOfProcess(processID: DebugProcessID) -> Task<[(DebugThreadID, DebugThreadState)]> {
//
//    }
//    func queryAllCakkStackFramesOfThread(threadID: DebugThreadID) -> Task<[(DebugCallStackFrameState)]> {
//
//    }
//
//    /// Dispatches a command which is usually a mutation.
//    func dispatch(command: DebugCommand) -> Task<()> {
//        let completion = TaskCompletionSource<()>()
//        dispatch_async(gcdq) { [weak self] in
//            guard let S = self else { return }
//            do {
//                try S.step(command).continueWithTask(continuation: { (task: Task<()>) -> Task<()> in
//                    assert(completion.task.completed == false)
//                    assert(completion.task.cancelled == false)
//                    switch task.state {
//                    case .Pending:
//                        fatalError("Cannot be pending state now.")
//                    case .Cancelled:
//                        completion.cancel()
//                    case .Error(let error):
//                        completion.setError(error)
//                    case .Success(let result):
//                        completion.setResult(result)
//                    }
//                })
//            }
//            catch let error {
//                assert(completion.task.completed == false)
//                completion.trySetError(error)
//            }
//        }
//        return completion.task
//    }
//    private func step(command: DebugCommand) throws -> Task<()> {
//        assert(qchk.check())
//        switch command {
//        case .AddTarget(let targetID, let u):
//            guard u.fileURL else { throw DebugError.BadParameter(u, message: "URL must be a file-URL.") }
//            guard let p = u.path else { throw DebugError.BadParameter(u, message: "Cannot get `path` from the URL.") }
//            let target = lldb.createTargetWithFilename(p, andArchname: LLDBArchDefault64Bit)
//            targetMapping[targetID] = target
//
//        case .RemoveTarget(let targetID):
//            guard let target = targetMapping.removeValueForKey(targetID) else { throw DebugError.InconsistenctState(message: "Target ID `\(targetID)` is missing in current target mapping.") }
//            lldb.deleteTarget(target)
//
//        case .LaunchTarget(let targetID):
//            guard let lldbTarget = targetMapping[targetID] else { throw DebugError.InconsistenctState(message: "No target for ID `\(targetID)`.") }
//            guard let _ = lldbTarget.launchProcessSimplyWithWorkingDirectory(".") else { throw DebugError.OperationFailure(message: "LLDB couldn't launch the target for ID `\(targetID)`.") }
//
//            guard state.sessions[sessionID] != nil else { throw DebugError.MissingSession(sessionID) }
//            state.sessions[sessionID] = DebugSessionState(executableURL: executableURL,
//                                                          processID: nil,
//                                                          phase: .NotStarted,
//                                                          threads: [:],
//                                                          variables: [])
//
//            lldb.create
//
//        case .HaltSession(let sessionID):
//            assert(state.sessions[sessionID] != nil)
//            state.sessions[sessionID] = nil
//        }
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
