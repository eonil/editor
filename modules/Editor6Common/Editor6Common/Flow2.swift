//
//  Flow2.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/03/05.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

///
/// Provides asynchronous execution context.
///
/// - `queue` some stepping function,
/// - and `signal` when you completed.
///
/// Flow execute queued function and wait until you
/// signal. Flow will continue executing next queued
/// function and wait. Repeat.
///
/// "Waiting" is indefinite by default. You MUST
/// signal at some future point. You can implement
/// "pause/resume" concept using this waiting stuff.
///
public final class Flow2<T: AnyObject> {
    private typealias ExecuteFunction = (_ context: T) -> ()
    private typealias WaiterWhileCondition = (_ context: T) -> Bool
    private var tmr = Timer?.none
    private var stepq = Flow2Queue<Flow2Step<T>>()
    private var waiter = WaiterWhileCondition?.none

    ///
    /// Flow weakly captures `context` and
    /// provides it to each stepping functions.
    /// Flow cancels automatically if it
    /// discovers the context object has been
    /// dead.
    ///
    /// - Note:
    ///     This is designed to be set after
    ///     `init` completed to allow you can
    ///     use arbitrary `self` as context.
    ///
    public weak var context = T?.none {
        willSet { assertMainThread() }
    }

    ///
    /// Creates a manually signaled flow.
    ///
    public init() {
        assertMainThread()
    }
    ///
    /// Creates an autosignaled flow.
    /// Created flow will be signaled automatically
    /// periodically by a timer.
    ///
    public init(autosignal: TimeInterval) {
        assertMainThread()
        remakeTimer(with: autosignal)
    }
    deinit {
        assertMainThread()
        assert(stepq.isEmpty, "There're some unexecuted steps...")
        killTimer()
    }

    ///
    /// Queues a new stepping.
    ///
    public func queue(_ step: Flow2Step<T>) {
        assertMainThread()
        stepq.enqueue(step)
        processAllIfPossible()
    }
    ///
    /// Signals flow to check current waiting is expired or not.
    /// No-op if this flow is not under waiting currently.
    ///
    public func signal() {
        assertMainThread()
        processAllIfPossible()
    }
    ///
    /// Cancels all unexecuted steps.
    /// A step which is being executed won't be affected.
    ///
    func cancel() {
        assertMainThread()
        stepq = Flow2Queue()
    }
    private func processAllIfPossible() {
        assertMainThread()
        guard let ctx = context else {
            cancel()
            return
        }
        while true {
            if let w = waiter, w(ctx) { break }
            guard let s = stepq.dequeue() else { break }
            switch s {
            case .execute(let f):
                f(ctx)
            case .wait(let c):
                waiter = c
            }
        }
    }
    private func remakeTimer(with interval: TimeInterval) {
        tmr = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let ss = self else { return }
            ss.signal()
        }
    }
    private func killTimer() {
        tmr = nil
    }
}

public extension Flow2 {
    public func execute(_ f: @escaping (_ context: T) -> ()) {
        queue(.execute(f))
    }
    public func wait(_ c: @escaping (_ context: T) -> Bool) {
        queue(.wait(while: c))
    }
}

public enum Flow2Step<T> {
    case execute((_ context: T) -> ())
    ///
    /// You can put any function as condition.
    /// `Flow` calls `while` on `signal` and
    /// resumes if it returns `false`.
    ///
    case wait(while: (_ context: T) -> Bool)
}

private struct Flow2Queue<T> {
    private var buf = [T]()
    var isEmpty: Bool {
        return buf.isEmpty
    }
    mutating func enqueue(_ v: T) {
        buf.append(v)
    }
    mutating func dequeue() -> T? {
        if buf.isEmpty { return nil }
        return buf.removeFirst()
    }
}
