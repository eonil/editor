//
//  BoltsExtensions.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import BoltsSwift

enum TaskState<TResult> {
    case Pending
    case Success(TResult)
    case Error(ErrorType)
    case Cancelled

    static func fromClosure(@noescape closure: () throws -> TResult) -> TaskState {
        do {
            return .Success(try closure())
        } catch is CancelledError {
            return .Cancelled
        } catch {
            return .Error(error)
        }
    }
}

extension Task {
    var state: TaskState<TResult> {
        if cancelled { return .Cancelled }
        if completed == false { return .Pending }
        if let error = error { return .Error(error) }
        if let result = result { return .Success(result) }
        fatalError("Invalidate state... Cannot determine current state.")
    }
}