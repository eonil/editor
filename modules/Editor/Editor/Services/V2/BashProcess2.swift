//
//  BashProcess2.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/25.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

///
/// You create this object, and the bash process
/// start immediately and automatically.
///
/// You are supposed to poll on this object to
/// determine to know what's going on this object.
///
/// This object provides timing signals for each
/// important moments, but with no contextual
/// information. Anyway, polling only on the 
/// signals should be enough to track major events.
///
/// You're responsible to keep this object alive 
/// until the process finishes. Killing this 
/// object before process finish make
/// connected subprocess to be `SIGKILL`ed.
/// If you want to ensure proper subprocess exit,
/// always wait until `state.isRunning == false`.
///
final class BashProcess2 {
    let signal = Relay<()>()
    private let loop = ManualLoop()
    private let proc = Process()
    private let stdin = Pipe()
    private let stdout = Pipe()
    private let stderr = Pipe()

    private(set) var state = State.running
    private(set) var props = Props()
    private var cmdq = [Command]()

    init(login: Bool) {
        assertMainThread()
        loop.step = { [weak self] in self?.step() }
        
        // Wire-up event handlers.
        do {
            do {
                typealias F = FunctionUtility
                let ss = Weak(self)
                let sig = { ss.deref?.loop.signal() ?? Void() }
                let qout = { ss.deref?.props.stdout.append($0) ?? Void() }
                let qerr = { ss.deref?.props.stderr.append($0) ?? Void() }
                let outFile = stdout.fileHandleForReading
                let errFile = stderr.fileHandleForReading
                outFile.readabilityHandler = read | toMainGCDQ(qout | sig)
                errFile.readabilityHandler = read | toMainGCDQ(qerr | sig)
                proc.terminationHandler = ignoreParameter | toMainGCDQ(sig)
            }
        }
        proc.launchPath = "/bin/bash"
        proc.arguments = (login ? ["--login"] : []) + ["-s"]
        proc.standardInput = stdin
        proc.standardOutput = stdout
        proc.standardError = stderr
        proc.launch()
        DEBUG_log("Launched a Bash subprocess: \(proc.processIdentifier)")
    }
    deinit {
        assertMainThread()
        assert(state.isRunning == false, "A BashSession `\(self)` has been terminated unexpectedily while running.")
        if state.isRunning {
            kill(proc.processIdentifier, SIGKILL)
            proc.waitUntilExit()
        }
    }
    private func step() {
        assertMainThread()
        switch state.isRunning {
        case true:
            while let c = cmdq.removeFirstIfAvailable() {
                switch c {
                case .setPrimary:   proc.qualityOfService = .utility
                case .setSecondary: proc.qualityOfService = .background
                case .stdin(let d): stdin.fileHandleForWriting.write(d)
                case .terminate:    proc.terminate()
                }
            }
            state = proc.isRunning ? .running : .complete(proc.terminationStatus)

        case false:
            REPORT_recoverableWarning("Stepping triggered after subprocess terminated.")
        }
        signal.cast()
        DEBUG_log("Bash subprocess isrunning: \(proc.isRunning)")
        DEBUG_log("Bash state: \(state)")
    }
    ///
    /// Controls linked subprocess.
    ///
    /// All commands are executed asynchronously.
    ///
    func queue(_ c: Command) {
        assertMainThread()
        cmdq.append(c)
        loop.signal()
    }
    func clearStandardOutput() {
        assertMainThread()
        props.stdout = []
    }
    func clearStandardError() {
        assertMainThread()
        props.stderr = []
    }
}
extension BashProcess2 {
    enum State {
        case running
        case complete(Int32)

        var isRunning: Bool {
            if case .running = self { return true }
            return false
        }
    }
    struct Props {
        var stdout = [Data]()
        var stderr = [Data]()
    }
    enum Command {
        case setPrimary
        case setSecondary
        ///
        /// This command is NOT idempotent.
        /// Duplicated call can make multiple effects.
        ///
        case stdin(Data)
        ///
        /// Send SIGTERM to bash subprocess.
        /// This will make it terminate gracefully.
        ///
        /// Idempotent.
        ///
        case terminate
    }
}


