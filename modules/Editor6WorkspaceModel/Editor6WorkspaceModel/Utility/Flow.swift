//
//  Steppintg.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/02.
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
final class Flow {
    private var tmr = Timer?.none
    private var stepq = Queue<FlowStep>()
    private var waiter = (() -> Bool)?.none

    ///
    /// Creates a manually signaled flow.
    ///
    init() {
        assertMainThread()
    }
    ///
    /// Creates an autosignaled flow.
    /// Created flow will be signaled automatically
    /// periodically by a timer.
    ///
    init(autosignal: TimeInterval) {
        assertMainThread()
        remakeTimer(with: autosignal)
    }
    deinit {
        assertMainThread()
        assert(stepq.isEmpty, "There're some unexcuted steps...")
    }

    ///
    /// Queues a new stepping.
    ///
    func queue(_ step: FlowStep) {
        assertMainThread()
        stepq.enqueue(step)
        processAllIfPossible()
    }
    ///
    /// Signals flow to check current waiting is expired or not.
    /// No-op if this flow is not under waiting currently.
    ///
    func signal() {
        assertMainThread()
        processAllIfPossible()
    }
    ///
    /// Cancels all unexecuted steps.
    /// A step which is being executed won't be affected.
    ///
    func cancel() {
        assertMainThread()
        stepq = Queue()
    }
    private func processAllIfPossible() {
        assertMainThread()
        while true {
            let canContinue = waiter?() ?? true
            guard canContinue else { return }
            guard let s = stepq.dequeue() else { return }
            switch s {
            case .execute(let f):
                f()
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

extension Flow {
    func execute(_ f: @escaping () -> ()) {
        queue(.execute(f))
    }
    func wait(_ c: @escaping () -> Bool) {
        queue(.wait(while: c))
    }
}

enum FlowStep {
    case execute(() -> ())
    ///
    /// You can put any function as condition.
    /// `Flow` calls `while` on `signal` and
    /// resumes if it returns `false`.
    ///
    case wait(while: () -> Bool)
}

