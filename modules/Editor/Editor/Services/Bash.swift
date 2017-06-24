//
//  Bash.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/16.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilSignet

struct Bash {
    ///
    /// Executes a command synchronously in a Bash shell
    /// in non-interactive mode, and returns STDOUT.
    ///
    /// This function is re-entrant and can be called from
    /// any thread.
    ///
    /// This function blocks caller GCDQ using semaphore
    /// until command execution finishes.
    ///
    /// - Returns:
    ///     `nil` if the command exit with non-zero value.
    ///     `nil` if command output is not decodable with
    ///     UTF-8.
    ///     `nil` if command could not be executed for any
    ///     reason.
    ///     Otherwise, captured output of STDOUT.
    ///     Any output from STDERR will be ignored.
    ///
    /// - Note:
    ///     If the command does not exit, this blocks caller
    ///     forever.
    ///
    static func eval(_ command: String, _ arguments: [String] = []) -> String? {
        let exec = BashExecution(command: command, arguments: arguments)
        let sema = DispatchSemaphore(value: 0)
        var buffer = Data()
        var ret = Int32(0)
        exec.event.delegate = { e in
            switch e {
            case .standardOutput(let d):
                buffer.append(d)
            case .exit(let code):
                ret = code
                sema.signal()
            default:
                break
            }
        }
        sema.wait()
        guard ret == 0 else { return nil }
        guard let s = String(data: buffer, encoding: .utf8) else { return nil }
        return s
    }

//    static func spawn(_ command: String, _ arguments: [String]) -> BashExecution {
//        return BashExecution(command: command, arguments: arguments)
//    }
}
///
/// Represents a non-interactive, batch Bash execution.
///
/// This is designed to provide incremental output from
/// a Bash subprocess. Spawned Bash subprocess won't be
/// connected to a terminal, and you cannot supply extra
/// commands to the Bash subprocess.
///
/// Killing this object before subprocess termination
/// forces sending SIGKILL to the spawned subprocess to
/// kill it immediately. This is sudden death, and 
/// subprocess can't perform any clean-up.
/// To guarantee clean graceful termination, you always
/// have to wait for `.exit` event.
///
/// Debug build will assert for such sudden death because
/// usually this sort of termination is highly undesired.
///
/// Interactive shell is unsupported because program usually
/// behaves in human-interface mode, which is inapproprite
/// for automated tool invocation. If you really need such
/// interactivity for humans, you SHOULD NOT use this class.
///
/// - Note:
///     This assumes system to have a Bash program executable
///     at a specified path. (`/bin/bash`). Otherwise, this
///     will make program to crash.
///
final class BashExecution {
    let event = Relay<Event>()
    private let proc = Process()
    private let stdin = Pipe()
    private let stdout = Pipe()
    private let stderr = Pipe()
    private(set) var state = State()

    init(command: String, arguments: [String], login: Bool = false) {
        func makeArguments() -> [String] {
            var a = [String]()
            if login { a.append("--login") }
            a.append("-c")
            a.append(command)
            a.append(contentsOf: arguments)
            return a
        }
        proc.launchPath = "/bin/bash"
        proc.arguments = makeArguments()
        proc.standardInput = stdin
        proc.standardOutput = stdout
        proc.standardError = stderr

        // Wire-up event handlers.
        do {
            let e = Weak(event)
            func setPipeOnRead(_ pipe: Pipe, toCast make: @escaping (Data) -> Event) {
                pipe.fileHandleForReading.readabilityHandler = { fileHandle in
                    e.deref?.cast(make(fileHandle.availableData))
                }
            }
            setPipeOnRead(stdout, toCast: Event.standardOutput)
            setPipeOnRead(stderr, toCast: Event.standardError)
        }
        proc.launch()
    }
    deinit {
        assert(state.phase != .running, "A BashSession `\(self)` has been terminated unexpectedily while running.")
        if state.phase != .exited {
            kill(proc.processIdentifier, SIGKILL)
        }
    }
    func process(_ c: Command) {
        switch c {
        case .initiate:
            guard state.phase == .unstarted else { return }
            state.phase = .running
            proc.launch()
        case .setPrimary:
            proc.qualityOfService = .utility
        case .setSecondary:
            proc.qualityOfService = .background
        case .standardInput(let d):
            stdin.fileHandleForWriting.write(d)
        case .terminate:
            guard state.phase != .exited else { return }
            proc.terminate()
        }
    }
}
extension BashExecution {
    struct State {
        var phase = Phase.unstarted
    }
    enum Phase {
        case unstarted
        case running
        case exited
    }
    enum Command {
        ///
        /// Launches the subprocess.
        /// Idempotent.
        ///
        case initiate
        case setPrimary
        case setSecondary
        ///
        /// This command is NOT idempotent.
        /// Duplicated call can make multiple effects.
        ///
        case standardInput(Data)
        ///
        /// Send SIGTERM to bash subprocess.
        /// This will make it terminate gracefully.
        ///
        /// Idempotent.
        ///
        case terminate
    }
    enum Event {
        case launch
        case standardOutput(Data)
        case standardError(Data)
        ///
        /// - Parameter $0: 
        ///     Exit code.
        ///
        case exit(Int32)
    }
}
