//
//  Result.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

public enum Result<V,E> {
    case success(V)
    case failure(E)
}

public extension Result {
    public var solution: V? {
        guard case .success(let v) = self else { return nil }
        return v
    }
    public var issue: E? {
        guard case .failure(let err) = self else { return nil }
        return err
    }
    public func mapSolution<V1>(_ f: (V) -> V1) -> Result<V1,E> {
        switch self {
        case .failure(let issue):
            return .failure(issue)
        case .success(let solution):
            return .success(f(solution))
        }
    }
    public func combine<V1>(_ f: (V) -> Result<V1,E>) -> Result<V1,E> {
        switch self {
        case .failure(let issue):
            return .failure(issue)
        case .success(let solution):
            return f(solution)
        }
    }
    public func unwrapSolution(_ processIssue: (E) -> Never) -> V {
        switch self {
        case .failure(let issue):
            processIssue(issue)
        case .success(let solution):
            return solution
        }
    }
}
