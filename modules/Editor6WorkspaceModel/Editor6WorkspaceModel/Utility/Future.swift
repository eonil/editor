////
////  Future.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/29.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//public enum Result<T> {
//    case ok(T)
//    case cancel
//    case error(Error)
//}
//
/////
///// - Note:
/////     Guarantees synchronous execution unless you
/////     explicitly shift to another GCD queue.
/////
//public final class Future<T> {
//    private var DEBUG_info = [String: String]()
//
//    fileprivate private(set) var state: FutureState<T>
//    private let lock = NSLock()
//
//    fileprivate init(state: FutureState<T>) {
//        DEBUG_info["init"] = Thread.callStackSymbols.joined(separator: "\n")
//        DEBUG_info["init/state"] = "\(state)"
//        self.state = state
//    }
//    deinit {
//        assert({
//            if case .consumed = state { return true }
//            return false
//        }(), "A future must finish with `.consumed` state. You use terminal `.step(...)` function, or `.cleanse(...)` at last of a flow.")
//    }
//    internal func setContinuation(_ f: @escaping (Result<T>) -> ()) {
//        lock.lock()
//        DEBUG_info["setContinuation"] = Thread.callStackSymbols.joined(separator: "\n")
//        switch state {
//        case .immature:
////            let f1 = { [self] f($0) }
//            state = .scheduled({ [s = self] in f($0); print(s) })
//        case .presignaled(let r):
//            f(r)
//            state = .consumed
//        case .scheduled(let s):
//            fatalError()
//        case .consumed:
//            fatalError()
//        }
//        lock.unlock()
//    }
//    internal func signal(_ r: Result<T>) {
//        lock.lock()
//        DEBUG_info["signal"] = Thread.callStackSymbols.joined(separator: "\n")
//        switch state {
//        case .immature:
//            state = .presignaled(r)
//        case .presignaled(let r):
//            fatalError()
//        case .scheduled(let s):
//            s(r)
//            state = .consumed
//        case .consumed:
//            fatalError()
//        }
//        lock.unlock()
//    }
//}
//
//extension Future {
//    /// Creates a unsignaled, unscheduled future.
//    convenience init() {
//        self.init(state: .immature)
//    }
//    /// Creates a pre-signaled future with a result.
//    convenience init(result: Result<T>) {
//        self.init(state: .presignaled(result))
//    }
//    /// Creates a pre-signaled future with an OK result.
//    convenience init(ok: T) {
//        self.init(result: .ok(ok))
//    }
//    /// Creates a pre-signaled future with an error result.
//    convenience init(error: Error) {
//        self.init(result: .error(error))
//    }
//    /// Creates a pre-signaled Future with result of supplied function.
//    /// - Parameter f:
//    ///     Produces an OK signal. If this function throws, 
//    ///     it is treated like a error signal.
//    convenience init(step f: () throws -> (T)) {
//        do {
//            let v = try f()
//            self.init(ok: v)
//        }
//        catch let e {
//            self.init(error: e)
//        }
//    }
//    /// Explicitly handle possible error.
//    public func cleanse(_ f: @escaping (Error) -> ()) {
//        setContinuation { (r: Result<T>) in
//            switch r {
//            case .ok(_):
//                break
//            case .cancel:
//                break
//            case .error(let e):
//                f(e)
//            }
//        }
//    }
//    public func step(_ f: @escaping (Result<T>) -> ()) {
//        setContinuation(f)
//    }
//    public func step(_ f: @escaping (Result<T>) -> (Result<T>)) -> Future<T> {
//        let f1 = Future<T>()
//        setContinuation({ (r: Result<T>) in
//            f1.signal(f(r))
//        })
//        return f1
//    }
//    public func step<U>(_ f: @escaping (T) throws -> (U)) -> Future<U> {
//        let f1 = Future<U>()
//        setContinuation { (r: Result<T>) in
//            switch r {
//            case .ok(let v):
//                do {
//                    let v1 = try f(v)
//                    f1.signal(.ok(v1))
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
////    /// Signals next future when this future signaled.
////    /// - Returns: `to`.
////    public func step(to: Future<T>) -> Future<T> {
////        setContinuation { (r: Result<T>) in
////            to.signal(r)
////        }
////        return to
////    }
//    /// Continues to a new future which will be created by a function.
//    /// - Parameter to:
//    ///     A function will generate a future to continue on.
//    ///     This function will only be called only once.
//    public func step<U>(to: @escaping (Result<T>) -> Future<U>) -> Future<U> {
//        let f1 = Future<U>()
//        setContinuation { (r1: Result<T>) in
//            let f2 = to(r1)
//            f2.setContinuation({ (r2: Result<U>) in
//                f1.signal(r2)
//            })
//        }
//        return f1
//    }
//
//    /// Same with other overload, but this skips `to`
//    /// if current continuation finished with an error.
//    public func step<U>(to: @escaping (T) -> Future<U>) -> Future<U> {
//        return step(to: { (r: Result<T>) -> Future<U> in
//            switch r {
//            case .ok(let v):
//                return to(v)
//            case .cancel:
//                return Future<U>(result: .cancel)
//            case .error(let e):
//                return Future<U>(error: e)
//            }
//        })
//    }
////    public func step<U>(_ f: @escaping (_ result: T, _ signal: @escaping (Result<U>) -> ()) -> ()) -> Future<U> {
////        let f1 = Future<U>()
////        setContinuation { (r: Result<T>) in
////            switch r {
////            case .ok(let v):
////                f(v) { s in f1.signal(s) }
////            case .cancel:
////                f1.signal(.cancel)
////            case .error(let e):
////                f1.signal(.error(e))
////            }
////        }
////    }
//    public func transfer(to q: DispatchQueue) -> Future<T> {
//        let f = Future<T>()
//        setContinuation { (r: Result<T>) in
//            q.async {
//                f.signal(r)
//            }
//        }
//        return f
//    }
//}
//
//private enum FutureState<T> {
//    case immature
//    case presignaled(Result<T>)
//    case scheduled((Result<T>) -> ())
//    case consumed
//}
