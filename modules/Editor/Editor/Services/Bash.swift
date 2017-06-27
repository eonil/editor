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
        let exec = BashProcess2(login: false)
        let sema = DispatchSemaphore(value: 0)
        let buffer = MutableBox<Data>(Data())
        var ret = Int32(0)
        exec.signal.delegate = { [exec, buffer] in
            switch exec.state {
            case .complete(let exitCode):
                exec.props.stdout.forEach({ buffer.value.append($0) })
                ret = exitCode
                sema.signal()
            default:
                break
            }
        }
        sema.wait()
        guard ret == 0 else { return nil }
        guard let s = String(data: buffer.value, encoding: .utf8) else { return nil }
        return s
    }

//    static func spawn(_ command: String, _ arguments: [String]) -> BashExecution {
//        return BashExecution(command: command, arguments: arguments)
//    }
}











