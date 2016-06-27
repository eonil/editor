//
//  ErrorReporting.swift
//  Editor4
//
//  Created by Hoon H. on 2016/06/27.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Dispatch

/// Critical error is a recoverable error that can possibly make undefined state so need to be reported.
/// Critical error occurs when program meets some paradox and cannot find logical solution.
/// Programmers need to program defensively to make program don't crash, but this kind of errors need to be notified to someone
/// -- mostly developers. So this repoter has been built.
/// Fatal errors are non-recoverable error which make program crash immediately. Reporter will try to report fatal errors too,
/// but actually nothing can be guaranteed in fatal error situation, so it's just depends on pure luck.
struct CriticalError: ErrorType {
    var code: CriticalErrorCode
    var message: String
}
enum CriticalErrorCode {
}
struct ErrorReporting {
    private static let gcdq = dispatch_queue_create("ErrorReportingDispatchQueue", DISPATCH_QUEUE_SERIAL)!
    static var delegate: (ErrorType) -> () = { error in
        assert(false, "A critial (or fatal) error occured: \(error)")
    }
    static func dispatch(error: CriticalError) {
        dispatch_async(gcdq) {
            ErrorReporting.delegate(error)
        }
    }
}