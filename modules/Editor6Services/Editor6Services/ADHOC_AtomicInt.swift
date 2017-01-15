//
//  ADHOC_AtomicInt.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

final class ADHOC_AtomicInt {
    private let lock = NSLock()
    private var value = Int(0)
    init() {
    }
    init(_ newState: Int) {
        state = newState
    }
    var state: Int {
        get {
            let returningValue: Int
            lock.lock()
            returningValue = value
            lock.unlock()
            return returningValue
        }
        set {
            lock.lock()
            value = newValue
            lock.unlock()
        }
    }
}
