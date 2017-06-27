////
////  BashExecution.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/25.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import Foundation
//
/////
///// Represents a non-interactive, batch Bash execution.
/////
///// This is designed to provide incremental output from
///// a Bash subprocess. Spawned Bash subprocess won't be
///// connected to a terminal, and you cannot supply extra
///// commands to the Bash subprocess.
/////
///// Killing this object before subprocess termination
///// forces sending SIGKILL to the spawned subprocess to
///// kill it immediately. This is sudden death, and
///// subprocess can't perform any clean-up.
///// To guarantee clean graceful termination, you always
///// have to wait for `.exit` event.
/////
///// Debug build will assert for such sudden death because
///// usually this sort of termination is highly undesired.
/////
///// Interactive shell is unsupported because program usually
///// behaves in human-interface mode, which is inapproprite
///// for automated tool invocation. If you really need such
///// interactivity for humans, you SHOULD NOT use this class.
/////
///// - Note:
/////     This assumes system to have a Bash program executable
/////     at a specified path. (`/bin/bash`). Otherwise, this
/////     will make program to crash.
/////
//final class BashExecution {
//    let event = Relay<Event>()
//    private let loop = ManualLoop()
//    private let proc = Process()
//    private let stdin = Pipe()
//    private let stdout = Pipe()
//    private let stderr = Pipe()
//
//    private var fsm = State.serial([.none, .running, .complete])
//    private var cmdq = [Command]()
//    private var stdoutq = [Data]()
//    private var stderrq = [Data]()
//
//    init(command: String, arguments: [String], login: Bool = false) {
//        loop.step = { [weak self] in self?.step() }
//        func makeArguments() -> [String] {
//            var a = [String]()
//            if login { a.append("--login") }
////            a.append("-c")
////            let comp = ([command] + arguments).joined(separator: " ").replacingOccurrences(of: "\"", with: "\\\"")
////            a.append("\"\(comp)\"")
//            a.append("-c")
//            a.append(command)
//            a.append(contentsOf: arguments)
//            return a
//        }
//        proc.launchPath = "/bin/bash"
//        proc.arguments = makeArguments()
//        proc.standardInput = stdin
//        proc.standardOutput = stdout
//        proc.standardError = stderr
//
//        // Wire-up event handlers.
//        do {
//            let ss = Weak(self)
//            let sig = { ss.deref?.loop.signal() ?? Void() }
//            func outq(_ d: Data) { ss.deref?.stdoutq.append(d) }
//            func errq(_ d: Data) { ss.deref?.stderrq.append(d) }
//            func bind(to call: @escaping (Data) -> Void) -> (FileHandle) -> Void {
//                return { h in
//                    let d = h.availableData // Read in current GCDQ.
//                    DispatchQueue.main.async { call(d) } // Call in main GCDQ.
//                }
//            }
//            stdout.fileHandleForReading.readabilityHandler = bind(to: outq | sig)
//            stderr.fileHandleForReading.readabilityHandler = bind(to: errq | sig)
//            proc.terminationHandler = { _ in } | sig
//        }
//    }
//    deinit {
//        assert(state != .running, "A BashSession `\(self)` has been terminated unexpectedily while running.")
//        if state != .complete {
//            kill(proc.processIdentifier, SIGKILL)
//        }
//    }
//    var state: State {
//        return fsm.current
//    }
//    private func step() {
//        switch fsm.current {
//        case .none:
//            precondition(stdoutq.isEmpty)
//            precondition(stderrq.isEmpty)
//            while let c = cmdq.removeFirstIfAvailable() {
//                switch c {
//                case .initiate:     fsm.set(to: .running) { event.cast(.launch) }
//                default:            REPORT_fatalError("Only `.launch` command is acceptable in `.none` state.")
//                }
//
//            }
//        case .running:
//            if proc.isRunning {
//                while let c = cmdq.removeFirstIfAvailable() {
//                    switch c {
//                    case .initiate:     break // Ignore to be idempotent.
//                    case .setPrimary:   proc.qualityOfService = .utility
//                    case .setSecondary: proc.qualityOfService = .background
//                    case .stdin(let d): stdin.fileHandleForWriting.write(d)
//                    case .terminate:    proc.terminate() // State will be set on termination handler.
//                    }
//                }
//            }
//            else {
//                let r = proc.terminationStatus
//                fsm.set(to: .complete) { event.cast(.exit(r)) }
//            }
//
//        case .complete:
//            while let c = cmdq.removeFirstIfAvailable() {
//                switch c {
//                case .terminate:    break // Ignore to be idempotent.
//                default:            REPORT_fatalError("Receive an extra command")
//                }
//            }
//        }
//    }
//    func process(_ c: Command) {
//        assertMainThread()
//        cmdq.append(c)
//        loop.signal()
//    }
//    private func processTermination() {
//        assertMainThread()
//        let r = proc.terminationStatus
//        event.cast(.exit(r))
//    }
//}
//extension BashExecution {
//    enum State {
//        /// Not started yet.
//        case none
//        /// In-progress...
//        case running
//        /// Exited regardless of how.
//        case complete
//    }
//    enum Command {
//        ///
//        /// Launches the subprocess.
//        /// Idempotent.
//        ///
//        case initiate
//        case setPrimary
//        case setSecondary
//        ///
//        /// This command is NOT idempotent.
//        /// Duplicated call can make multiple effects.
//        ///
//        case stdin(Data)
//        ///
//        /// Send SIGTERM to bash subprocess.
//        /// This will make it terminate gracefully.
//        ///
//        /// Idempotent.
//        ///
//        case terminate
//    }
//    enum Event {
//        case launch
//        case stdout(Data)
//        case stderr(Data)
//        ///
//        /// - Parameter $0:
//        ///     Exit code.
//        ///
//        case exit(Int32)
//    }
//}
