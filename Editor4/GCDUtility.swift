//
//  GCDUtility.swift
//  Editor4
//
//  Created by Hoon H. on 2016/06/04.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Dispatch

struct GCDUtility {
}

final class GCDQueueChecker {
    private weak var gcdq: dispatch_queue_t?
    private let key: UnsafeMutablePointer<UInt8>
    init(_ gcdq: dispatch_queue_t) {
        self.gcdq = gcdq
        key = UnsafeMutablePointer<UInt8>.alloc(1)
        let p = unsafeAddressOf(self)
        let p1 = unsafeBitCast(p, UnsafeMutablePointer<()>.self)
        dispatch_queue_set_specific(gcdq, key, p1, nil)
    }
    deinit {
        if let gcdq = gcdq {
            dispatch_queue_set_specific(gcdq, key, nil, nil)
        }
        key.dealloc(1)
    }
    func check() -> Bool {
        let p = dispatch_get_specific(key)
        let p1 = unsafeAddressOf(self)
        let p2 = unsafeBitCast(p1, UnsafeMutablePointer<()>.self)
        return (p == p2)
    }
}





















