//
//  Editor6ThreadChannel.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/03.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

final class Editor6ThreadChannel<T> {
    private let sem: Editor6ThreadSemaphore
    private let mutex = NSLock()
    private var buffer = [T]()
    private var isClosed = false
    private var delegate: ((T) -> ())?
    private var delegateMutex = NSLock()

    init() {
        sem = Editor6ThreadSemaphore()
    }
    deinit {
        dispatch(nil)
    }

    func signal(_ value: T) {
        delegateMutex.lock()
        let isRelayed = (delegate != nil)
        if let d = delegate {
            d(value)
        }
        delegateMutex.unlock()

        if isRelayed == false {
            dispatch(value)
        }
    }
    func halt() {
        delegateMutex.lock()
        let isRelayed = (delegate != nil)
        if isRelayed {
            delegate = nil
        }
        delegateMutex.unlock()

        if isRelayed == false {
            dispatch(nil)
        }
    }

    func wait() -> T? {
        mutex.lock()
        if isClosed { return nil }
        mutex.unlock()
        delegateMutex.lock()
        let isRelayed = (delegate != nil)
        delegateMutex.unlock()
        assert(isRelayed == false, "You cannot `wait` on relayed channel.")
        if isRelayed { return nil }

        return sem.wait { scan () }
    }
    func relay(to: @escaping (T) -> ()) {
        delegateMutex.lock()
        delegate = to
        delegateMutex.unlock()
    }

    private func dispatch(_ value: T?) {
        mutex.lock()
        if isClosed {
            assert(false, "This channel is already been closed.")
        }
        else {
            if let v = value {
                buffer.append(v)
            }
            else {
                isClosed = true
            }
        }
        sem.signal()
        mutex.unlock()
    }
    private func scan() -> T? {
        let r: T?
        mutex.lock()
        if isClosed {
//            assert(false, "This channel is already been closed.")
            r = nil
        }
        else {
            if buffer.count > 0 {
                r = buffer.removeFirst()
            }
            else {
                r = nil
            }
        }
        mutex.unlock()
        return r
    }
}
