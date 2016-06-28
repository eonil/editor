//
//  DebugService.swift
//  Editor4
//
//  Created by Hoon H. on 2016/06/02.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Dispatch
import LLDBWrapper
import BoltsSwift

//enum DebugCommand {
//    case AddTarget(DebugTargetID, executable: NSURL)
//    case RemoveTarget(DebugTargetID)
//    case LaunchTarget(DebugTargetID)
//    case HaltSession(DebugSessionID)
//}

typealias DebugThreadID = (targetID: DebugTargetID, threadIndex: UInt)
typealias DebugFrameID = (threadID: DebugThreadID, frameIndex: UInt32)

enum DebugError: ErrorType {
    case serviceUnavailable
    case missingTargetStateFor(DebugTargetID)
    case missingTargetMappingFor(DebugTargetID)
    case missingThreadFor(DebugThreadID)
    case missingFrameFor(DebugFrameID)
    case badURL(NSURL)
    case cannotLaunchProcessFor(DebugTargetID)
//    case BadParameter(Any, message: String)
//    case InconsistenctState(message: String)
//    case OperationFailure(message: String)
//    case MissingSession(DebugSessionID)
}

//enum DebugNotification {
//    case Step(DebugState)
//    case StepThread(DebugThreadID, DebugThreadState)
//    case StepStackFrame(DebugCallStackFrameState)
//}

private struct LocalState {
    var targetMapping = [DebugTargetID: LLDBTarget]()
    var proxyState = DebugState()
}

/// Manages debugging.
///
/// This abstracts any underlying specific debugging service.
/// For now, I use LLDB.
/// This service keeps internal local copy of debugging state,
/// and dispatches to driver whenever it changes. The debugging
/// state can be changed by external signal or program execution.
/// Many part of debugging states are available only when the 
/// target process is being paused. For example, there will be
/// no stack frame information while process is running.
/// Also, states are resolved lazily. For example, pausing 
/// target process won't make stack frame's local variables 
/// to be available. You have to dispatch "query local variables
/// of some stack frame" command explicitly to make it available.
///
final class DebugService: DriverAccessible {
    private let mutationGCDQ = dispatch_queue_create("\(DebugService.self)/mutationGCDQ", DISPATCH_QUEUE_SERIAL)!
    private let continuationGCDQ = dispatch_queue_create("\(DebugService.self)/continuationGCDQ", DISPATCH_QUEUE_SERIAL)!
    private let lldb: LLDBDebugger
    private let qchk: GCDQueueChecker

    private var localState = LocalState()

    init() {
        qchk = GCDQueueChecker(mutationGCDQ)
        LLDBGlobals.initializeLLDBWrapper()
        lldb = LLDBDebugger()
    }
    deinit {
        LLDBGlobals.terminateLLDBWrapper()
    }

    /// - Returns:
    ///     Completes when the target is
    func addTarget(executableURL u: NSURL) -> Task<DebugTargetID> {
        return process { [weak self] state in
            guard let s = self else { throw DebugError.serviceUnavailable }
            guard let p = u.path else { throw DebugError.badURL(u) }
            let debugTargetID = DebugTargetID()
            let lldbTarget = s.lldb.createTargetWithFilename(p, andArchname: LLDBArchDefault)
            state.targetMapping[debugTargetID] = lldbTarget
            state.proxyState.targets[debugTargetID] = DebugTargetState(executableURL: u, session: nil)
            return debugTargetID
        }
    }

    func removeTarget(debugTargetID: DebugTargetID) -> Task<()> {
        return process { [weak self] state in
            guard let s = self else { throw DebugError.serviceUnavailable }
            guard state.proxyState.targets.removeValueForKey(debugTargetID) != nil else { throw DebugError.missingTargetStateFor(debugTargetID) }
            guard let lldbTarget = state.targetMapping[debugTargetID] else { throw DebugError.missingTargetMappingFor(debugTargetID) }
            s.lldb.deleteTarget(lldbTarget)
            return ()
        }
    }

    /// Launches a new process for the target.
    func launchTarget(debugTargetID: DebugTargetID, workingDirectoryURL: NSURL) -> Task<()> {
        return process { state in
            guard let debugTargetState = state.proxyState.targets[debugTargetID] else { throw DebugError.missingTargetStateFor(debugTargetID) }
            guard let lldbTarget = state.targetMapping[debugTargetID] else { throw DebugError.missingTargetMappingFor(debugTargetID) }
            guard let workingDirectoryPath = workingDirectoryURL.path else { throw DebugError.badURL(workingDirectoryURL) }
            lldbTarget.launchProcessSimplyWithWorkingDirectory(workingDirectoryPath)
            guard let lldbProcess = lldbTarget.process else { throw DebugError.cannotLaunchProcessFor(debugTargetID) }
            let debugProcessState = scanProxyFrom(lldbTarget.process)
            state.proxyState.targets[debugTargetID]?.session = debugProcessState
        }
    }

//    /// Fetches local variable tree of a stack frame.
//    /// - Returns:
//    ///     A task which completes when the data is ready.
//    func fetchLocalVariablesOfStackFrame(debugFrameID: DebugFrameID) -> Task<()> {
//        return process { state in
//            guard let lldbTarget = state.targetMapping[debugFrameID.threadID.targetID] else { throw DebugError.missingTargetMappingFor(debugFrameID.threadID.targetID) }
//            guard let lldbThread = lldbTarget.process.threadAtIndex(debugFrameID.threadID.threadIndex) else { throw DebugError.missingThreadFor(debugFrameID.threadID) }
//            guard let lldbFrame = lldbThread.frameAtIndex(debugFrameID.frameIndex) else { throw DebugError.missingFrameFor(debugFrameID) }
//            lldbFrame.variablesWithArguments(true, locals: true, statics: true, inScopeOnly: false, useDynamic: LLDBDynamicValueType.NoDynamicValues)
//        }
//    }
//    func clearLocalVariables() -> Task<()> {
//
//    }


    private func process<T>(transaction transaction: (inout state: LocalState) throws -> T) -> Task<T> {
        return Task(()).continueIn(mutationGCDQ) { [weak self] () throws -> T in
            guard let s = self else { throw DebugError.serviceUnavailable }
            let s1 = try transaction(state: &s.localState)
            s.driver.userInteraction.dispatch { (inout userInteractionState: UserInteractionState) -> () in
                userInteractionState.debug = s.localState.proxyState
            }
            return s1
        }.continueIn(continuationGCDQ)
    }

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
}



private func scanProxyFrom(lldbProcess: LLDBProcess) -> DebugProcessState {
    var proxy = DebugProcessState()
    proxy.variables = .some
    proxy.threads = .some
    return proxy
}

private func scanProxyFrom(lldbThread: LLDBThread) -> DebugThreadState {
    lldbThread.threadID
    var thread = DebugThreadState(callStackFrames: [])
    return thread
}











