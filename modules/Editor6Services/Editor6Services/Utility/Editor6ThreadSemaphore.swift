//
//  Editor6ThreadSemaphore.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/03.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

final class Editor6ThreadSemaphore {
    private let cond = NSCondition()
    private let keepWaiting = SynchronizedState(true)
    deinit {
        keepWaiting.state = false
        cond.signal()
    }
    func signal() {
        cond.signal()
    }
    ///
    /// Waits and calls `f` until its result to be a non-nil value,
    /// and returns the value.
    ///
    /// - Parameter f:
    ///     A producer function which will be called repeatedly.
    ///     If this function returns `nil`, call to `wait` doesn't
    ///     return.
    ///
    func wait<T>(for f: () -> T?) -> T {
        var r = T?.none
        cond.lock()
        while keepWaiting.state {
            r = f()
            if r != nil { break }
            cond.wait()
        }
        cond.unlock()
        return r!
    }
}
private final class SynchronizedQueue<T> {
    private let lock = NSLock()
    private var buffer = [T]()
    func push(_ value: T) {
        lock.lock()
        buffer.append(value)
        lock.unlock()
    }
    func pop() -> T? {
        lock.lock()
        let popped = buffer.first
        if popped != nil { buffer.removeFirst() }
        lock.unlock()
        return popped
    }
    ///
    /// Pops olest value only if the value is type `U`.
    ///
    internal func pop<U>() -> U? {
        lock.lock()
        let popped = buffer.first as? U
        if popped != nil { buffer.removeFirst() }
        lock.unlock()
        return popped
    }
}
private final class SynchronizedState<T> {
    private let lock = NSLock()
    private var storage: T
    init(_ state: T) {
        storage = state
    }
    var state: T {
        get {
            lock.lock()
            let r = storage
            lock.unlock()
            return r
        }
        set {
            lock.lock()
            storage = newValue
            lock.unlock()
        }
    }
}
