//
//  Result.extension.REPORT.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/27.
//Copyright © 2017 Eonil. All rights reserved.
//

extension Result {
    var successValue: Value? {
        switch self {
        case .success(let v):   return v
        default:                return nil
        }
    }
    var isFailure: Bool {
        switch self {
        case .failure(_):   return true
        default:            return false
        }
    }
    func mapValue<T>(_ f: (Value) -> (T)) -> Result<T,Issue> {
        switch self {
        case .success(let value):   return .success(f(value))
        case .failure(let issue):   return .failure(issue)
        }
    }
    func mapIssue<U>(_ f: (Issue) -> (U)) -> Result<Value,U> {
        switch self {
        case .success(let value):   return .success(value)
        case .failure(let issue):   return .failure(f(issue))
        }
    }
}
