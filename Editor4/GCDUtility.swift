////
////  GCDUtility.swift
////  Editor4
////
////  Created by Hoon H. on 2016/06/04.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Dispatch
//
//struct GCDUtility {
//}
//
//final class QueueChecker {
//    private let key: UnsafeMutablePointer<UInt8>
//    init(_ gcdq: dispatch_queue_t) {
//        key = UnsafeMutablePointer<UInt8>.alloc(1)
//        let selfptr = unsafeAddressOf(self)
//        dispatch_queue_set_specific(gcdq, key, selfptr, nil)
//    }
//    deinit {
//        key.dealloc(1)
//    }
//    func check() -> Bool {
//        let curptr = dispatch_get_specific(key)
//        let selfptr = unsafeAddressOf(self)
//        return (curptr == selfptr)
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
