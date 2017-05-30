//
//  ADHOC_TextLineBashSubprocess.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/02.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import Editor6Common

/// Create a subprocess and executes Bash in there.
///
/// Requirements
/// ------------
/// - `/bin/bash` must be installed on system.
///
/// - Note:
///     Its impossible each command in Bash shell
///     finished or not. Instead you need to monitor
///     exit of the Bash shell itself, and reinstantiate
///     a new Bash shell for each command if you need
///     to track execution time of them.
///
final class ADHOC_TextLineBashSubprocess {
    private let subproc: Subprocess2Controller
    private var delegate = ((Event) -> ())?.none
    private var stdoutReader = LineReader()
    private var stderrReader = LineReader()

    enum Command {
        case launch
        case stdin(lines: [String])
    }
    enum Event {
        case stdout(lines: [String])
        case stderr(lines: [String])
        case term(exitCode: Int32)
    }

    init() {
//        subproc = Subprocess2Controller(path: "/bin/bash", arguments: ["--login", "--posix", "-i", "-s"])
        subproc = Subprocess2Controller(path: "/bin/bash", arguments: ["--login", "-s"])
        subproc.delegate { [weak self] in self?.process($0) }
        debugLog("init")
    }
    deinit {
        debugLog("deinit")
    }

    var phase: Subprocess2Phase {
        return subproc.state.phase
    }

    func delegate(to newDelegate: @escaping (Event) -> ()) {
        delegate = newDelegate
    }

    ///
    /// - Parameter newLines:
    ///     Exclude ending `\n` character.
    ///
    func queue(_ c: Command) {
        debugLog("queue \(c)")
        switch c {
        case .launch:
            subproc.queue(.launch)
        case .stdin(let lines):
            let s = lines.map({ $0 + "\n" }).joined()
            let d = s.data(using: .utf8) ?? Data()
            subproc.queue(.stdin(d))
        }
    }

    private func process(_ e: Subprocess2Event) {
        debugLog("event \(e)")
        switch e {
        case .stdout(let data):
            let newLines = stdoutReader.push(data: data)
            delegate?(.stdout(lines: newLines))
        case .stderr(let data):
            let newLines = stderrReader.push(data: data)
            delegate?(.stderr(lines: newLines))
        case .terminate(let exitCode):
            if stdoutReader.decodedString != "" {
                delegate?(.stdout(lines: [stdoutReader.decodedString]))
                stdoutReader = LineReader()
            }
            if stderrReader.decodedString != "" {
                delegate?(.stderr(lines: [stderrReader.decodedString]))
                stderrReader = LineReader()
            }
            delegate?(.term(exitCode: exitCode))
        }
    }

    private func debugLog(_ message: @autoclosure () -> String) {
        Editor6Common.debugLog(withAddressOf: self, message: "BASH \(message())")
    }
}



