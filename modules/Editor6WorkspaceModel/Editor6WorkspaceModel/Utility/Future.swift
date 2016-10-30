//
//  Future.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/29.
//  Copyright © 2016 Eonil. All rights reserved.
//

public enum Result<T> {
    case ok(T)
    case cancel
    case error(Error)
}

public final class Future<T> {
    fileprivate private(set) var state = FutureState<T>.immature
    private let lock = NSLock()

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
    public func setContinuation(_ f: @escaping (Result<T>) -> ()) {
        lock.lock()
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
        lock.unlock()
    }
    internal func signal(_ r: Result<T>) {
        lock.lock()
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
        lock.unlock()
    }
}

extension Future {
    convenience init(ok: T) {
        self.init(result: .ok(ok))
    }
    convenience init(error: Error) {
        self.init(result: .error(error))
    }
    public func step(_ f: @escaping (Result<T>) -> ()) {
        setContinuation(f)
    }
    public func step(_ f: @escaping (Result<T>) -> (Result<T>)) -> Future<T> {
        let f1 = Future<T>()
        setContinuation({ (r: Result<T>) in
            f1.signal(f(r))
        })
        return f1
    }
//    public func step<U>(_ f: @escaping (T) throws -> (U?)) -> Future<U> {
//        let f1 = Future<U>()
//        setContinuation { (r: Result<T>) in
//            switch r {
//            case .ok(let v):
//                do {
//                    let v1 = try f(v)
//                    if let v2 = v1 {
//                        f1.signal(.ok(v2))
//                    }
//                    else {
//                        f1.signal(.cancel)
//                    }
//                }
//                catch let e1 {
//                    f1.signal(.error(e1))
//                }
//            case .cancel:
//                f1.signal(.cancel)
//            case .error(let e):
//                f1.signal(.error(e))
//            }
//        }
//        return f1
//    }
    /// Available only if current future is already been signaled.
//    public func stepImmediately<U>(_ f: (T) throws -> (U)) -> Future<U> {
//        precondition({
//            if case .presignaled = state { return true }
//            return false
//        }())
//        switch state {
//        case .immature:
//            fatalError()
//        case .presignaled(let r):
//            switch r {
//            case .ok(let v):
//                do {
//                    let v1 = try f(v)
//                    return Future<U>(ok: v1)
//                }
//                catch let e {
//                    return Future<U>(error: e)
//                }
//            case .cancel:
//                return Future<U>(result: .cancel)
//            case .error(let e):
//                return Future<U>(error: e)
//            }
//        case .scheduled(_):
//            fatalError()
//        case .consumed:
//            fatalError()
//        }
//    }

    convenience init(step f: () throws -> (T)) {
        do {
            let v = try f()
            self.init(ok: v)
        }
        catch let e {
            self.init(error: e)
        }
    }
    public func step<U>(_ f: @escaping (T) throws -> (U)) -> Future<U> {
        let f1 = Future<U>()
        setContinuation { (r: Result<T>) in
            switch r {
            case .ok(let v):
                do {
                    let v1 = try f(v)
                    f1.signal(.ok(v1))
                }
                catch let e1 {
                    f1.signal(.error(e1))
                }
            case .cancel:
                f1.signal(.cancel)
            case .error(let e):
                f1.signal(.error(e))
            }
        }
        return f1
    }
//    /// Signals next future when this future signaled.
//    /// - Returns: `to`.
//    public func step(to: Future<T>) -> Future<T> {
//        setContinuation { (r: Result<T>) in
//            to.signal(r)
//        }
//        return to
//    }
    /// Continues to a new future which will be created by a function.
    /// - Parameter to:
    ///     A function will generate a future to continue on.
    ///     This function will only be called only once.
    public func step<U>(to: @escaping (Result<T>) -> Future<U>) -> Future<U> {
        let f1 = Future<U>()
        setContinuation { (r1: Result<T>) in
            let f2 = to(r1)
            f2.setContinuation({ (r2: Result<U>) in
                f1.signal(r2)
            })
        }
        return f1
    }

    /// Same with other overload, but this skips `to`
    /// if current continuation finished with an error.
    public func step<U>(to: @escaping (T) -> Future<U>) -> Future<U> {
        return step(to: { (r: Result<T>) -> Future<U> in
            switch r {
            case .ok(let v):
                return to(v)
            case .cancel:
                return Future<U>(result: .cancel)
            case .error(let e):
                return Future<U>(error: e)
            }
        })
    }
    public func transfer(to q: DispatchQueue) -> Future<T> {
        let f = Future<T>()
        setContinuation { (r: Result<T>) in
            q.async {
                f.signal(r)
            }
        }
        return f
    }
}

private enum FutureState<T> {
    case immature
    case presignaled(Result<T>)
    case scheduled((Result<T>) -> ())
    case consumed
}
