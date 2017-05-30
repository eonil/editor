//
//  DebugFeature.swift
//  Editor6Features
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import EonilToolbox
import EonilSignet
import LLDBWrapper
import Editor6Common
import Editor6Services

///
/// - Note:
///     If a target gets paused, related frame list will be refilled.
///
///
public final class DebugFeature {
    public weak var services: Services? { didSet { processDidSetService() } }
    private let chan = MutableChannel<State>(State())
    
    public var channel: Channel<State> {
        return chan
    }
    public func process(_ s: Command) {
        MARK_unimplemented()
    }
    private func processDidSetService() {
        MARK_unimplemented()
    }
}
public extension DebugFeature {
    public struct State {
        public var targets = [TargetID: TargetState]()
    }
    public struct Target {
        public let id = TargetID()
        public let state: TargetState
    }
    public typealias TargetID = ObjectAddressID
    public struct TargetState {
        public var executablePath: String
        public var phase = TargetPhase.invalid
        ///
        /// Always `[]` if current target is running.
        /// Filled automatically if current target gets paused.
        ///
        public var threads = [Thread]()
    }
    public typealias TargetPhase = LLDBStateType
    public typealias TargetExitCode = Int32
    public struct Thread {
        public let id: ThreadID
        public let state: ThreadState
    }
    public typealias ThreadID = UInt64
    public struct ThreadState {
        public var frames = [Frame]()
    }
    public struct Frame {
        public let id: FrameIndex
        public let state: FrameState
    }
    public typealias FrameIndex = UInt32
    public struct FrameState {
        public var name: String
    }
    public struct Variable {
        public var name: String
        public var value: String
        public var subvariables: [Variable]
    }
    public typealias VariablePath = [String]
    public struct Breakpoint {
        // NOSHIP:
    }


    public enum Command {
        case add(Target)
        case remove(Target)
        case launch(Target)
        case control(Target, TargetCommand)
        case halt(Target)
        case addBreakpoint(Breakpoint)
        case removeBreakpoint(Breakpoint)
    }
    public enum TargetCommand {
        case pause
        case resume
        case stepInto
        case stepOut
        case stepOver
        ///
        /// Queries current value at path.
        /// This can make debugger to resolve to the leaf node
        /// recursively. Any intermediate nodes will also be
        /// resolved.
        ///
        case query(VariablePath)
    }
}


private typealias Target = DebugFeature.Target
private typealias TargetID = DebugFeature.TargetID
private typealias TargetState = DebugFeature.TargetState
private typealias TargetPhase = DebugFeature.TargetPhase
private typealias Thread = DebugFeature.Thread
private typealias ThreadID = DebugFeature.ThreadID
private typealias ThreadState = DebugFeature.ThreadState
private typealias Frame = DebugFeature.Frame
private typealias FrameID = DebugFeature.FrameIndex
private typealias FrameState = DebugFeature.FrameState

private extension LLDBTarget {
    func makeTargetState() -> TargetState {
        return TargetState(
            executablePath: "NOSHIP: ????",
            phase: process.state,
            threads: process.allThreads.map({ $0.makeThread() }))
    }
}
private extension LLDBThread {
    func makeThread() -> Thread {
        return Thread(
            id: threadID,
            state: DebugFeature.ThreadState(
                frames: allFrames.flatMap({ $0?.makeFrame() })))
    }
}
private extension LLDBFrame {
    func makeFrame() -> Frame {
        return Frame(
            id: frameID,
            state: DebugFeature.FrameState(
                name: functionName))
    }
}









