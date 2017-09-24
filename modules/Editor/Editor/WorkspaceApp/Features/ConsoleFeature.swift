//
//  ConsoleFeature.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/29.
//  Copyright © 2017 Eonil. All rights reserved.
//

///
/// Provides pseudo I/O device for Editor process.
///
/// This creates a PTY device to connect to Editor's
/// stdin/stdout(+stderr).
///
///
///
final class ConsoleFeature: ServicesDependent {
    let signal = Relay<()>()
    private(set) var state = State()
}
extension ConsoleFeature {
    struct State {
        var messages = [String]()
    }
//    enum Agent {
//        ///
//        /// You input will be encoded as UTF-8
//        /// and sent to the process as is. Same
//        /// for process output.
//        ///
//        case none
//        ///
//        ///
//        ///
//        case lldb
//        ///
//        /// Uses system Bash (`/bin/bash`) as shell.
//        ///
//        case bash
//        ///
//        /// Uses MIR interpreter as shell.
//        /// Which means you use Rust languae as a
//        /// shell script.
//        ///
//        @available(*, unavailable)
//        case miri
//        ///
//        /// Uses Swift interpreter as shell.
//        ///
//        case swift
//    }
}
