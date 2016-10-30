//
//  Future.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/29.
//  Copyright © 2016 Eonil. All rights reserved.
//

public enum Result<T> {
    case ok(T)
    case error(Error)
}
public final class Future<T> {
    private var state = FutureState<T>.immature

    init() {
    }
    init(result: Result<T>) {
        state = .presignaled(result)
    }
    deinit {
        assert({
            if case .consumed = state { return true }
            return false
        }())
    }
    public func step(_ f: @escaping (Result<T>) -> ()) {
        switch state {
        case .immature:
            state = .scheduled(f)
        case .presignaled(let r):
            f(r)
            state = .consumed
        case .scheduled(let s):
            fatalError()
        case .consumed:
            fatalError()
        }
    }
    internal func signal(_ r: Result<T>) {
        switch state {
        case .immature:
            state = .presignaled(r)
        case .presignaled(let r):
            fatalError()
        case .scheduled(let s):
            s(r)
            state = .consumed
        case .consumed:
            fatalError()
        }
    }
    internal func makeSignalingContinuation(with r: Result<T>) -> ModelContinuation {
        return { self.signal(r) }
    }
}

extension Future {
    convenience init(ok: T) {
        self.init(result: .ok(ok))
    }
    convenience init(error: Error) {
        self.init(result: .error(error))
    }
    public func step<U>(_ f: @escaping (T) throws -> (U)) -> Future<U> {
        let f1 = Future<U>()
        step { (r: Result<T>) in
            switch r {
            case .ok(let v):
                do {
                    let v1 = try f(v)
                    f1.signal(.ok(v1))
                }
                catch let e1 {
                    f1.signal(.error(e1))
                }
            case .error(let e):
                f1.signal(.error(e))
            }
        }
        return f1
    }
}

private enum FutureState<T> {
    case immature
    case presignaled(Result<T>)
    case scheduled((Result<T>) -> ())
    case consumed
}
