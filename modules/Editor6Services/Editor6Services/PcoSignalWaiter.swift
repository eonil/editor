//
//  PcoSignalWaiter.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

///
/// Simplified version of `NSCondition` which locks automatically.
///
public final class PcoThreadSignalWaiter {
    private let cond = NSCondition()
    public func signal() {
        cond.lock()
        cond.signal()
        cond.unlock()
    }
    public func wait() {
        cond.lock()
        cond.wait()
        cond.unlock()
    }
}
