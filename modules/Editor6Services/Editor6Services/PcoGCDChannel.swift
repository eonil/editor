////
////  GCDPcoChannel.swift
////  Editor6Services
////
////  Created by Hoon H. on 2017/01/14.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import Foundation
//import EonilGCDActor
////
////final class PcoGCDChannel<T>: PcoChannel {
////    private typealias CoreGCDChannel = GCDChannel<T?>
////    private let gcdch = CoreGCDChannel()
////    private let DEBUG_isWaitingFlag = ADHOC_AtomicBool(false)
////    private let DEBUG_isClosedFlag = ADHOC_AtomicBool(false)
////
////    private(set) var isWaiting: Bool {
////        get { return DEBUG_isWaitingFlag.state }
////        set { DEBUG_isWaitingFlag.state = newValue }
////    }
////    private(set) var isClosed: Bool {
////        get { return DEBUG_isClosedFlag.state }
////        set { DEBUG_isClosedFlag.state = newValue }
////    }
////    func send(_ signal: T?) {
////        precondition(signal == nil || isClosed == false)
////        guard isClosed == false else { return }
////        if let s = signal {
////            gcdch.send(s)
////        }
////        else {
////            isClosed = true
////            // Make it to send `nil` for first time to signal end of stream.
////            if isWaiting {
////                gcdch.send(nil)
////            }
////        }
////    }
////    func receive() -> T? {
////        guard isClosed == false else { return nil }
////        let returningValue: T?
////        isWaiting = true
////        returningValue =  gcdch.receive()
////        isWaiting = false
////        return returningValue
////    }
////}
//
////final class PcoGCDChannel<T>: PcoChannel {
////    private let sendCond = NSConditionLock(condition: 0)
////    private let recvCond = NSConditionLock(condition: 0)
////    private var slot = T?.none
////    private let isClosedFlag = ADHOC_AtomicBool(false)
////
////    private let IDLE = Int(0)
////    private let WAITING = Int(1)
////    private let DONE = Int(2)
//////    private let SEND_DONE = Int(3)
//////    private let RECV_DONE = Int(4)
////
////    init() {
////
////    }
////    deinit {
////        assert(slot == nil, "`slot != nil` on `dealloc`.")
////    }
////    var isClosed: Bool {
////        get { return isClosedFlag.state }
////        set { isClosedFlag.state = newValue }
////    }
////    func send(_ signal: T?) {
////        guard let s = signal else {
////            isClosed = true
////            // From now on, `receive` won't read from `slot` anymore.
////            slot = nil
////            return
////        }
////        sendCond.lock(whenCondition: IDLE)
////        sendCond.unlock(withCondition: WAITING)
////        recvCond.lock(whenCondition: WAITING)
////        sendCond.lock(whenCondition: WAITING)
////        slot = s
////        sendCond.unlock(withCondition: IDLE)
////        recvCond.unlock(withCondition: IDLE)
////    }
////    func receive() -> T? {
////        guard isClosed == false else { return nil }
////        let r: T?
////        recvCond.lock(whenCondition: IDLE)
////        recvCond.unlock(withCondition: WAITING)
////        sendCond.lock(whenCondition: WAITING)
////        recvCond.lock(whenCondition: WAITING)
////        r = slot
////        slot = nil
////        sendCond.unlock(withCondition: IDLE)
////        recvCond.unlock(withCondition: IDLE)
////        return r
////    }
////}
//
////final class PcoGCDChannel<T>: PcoChannel {
////    private let sendReadySema = DispatchSemaphore(value: 0)
////    private let sendDoneSema = DispatchSemaphore(value: 0)
////    private let recvReadySema = DispatchSemaphore(value: 0)
////    private let recvDoneSema = DispatchSemaphore(value: 0)
////    private let slotLock = NSLock()
////    private var slot = T?.none
////    private let adhoc_isClosed_store = ADHOC_AtomicBool(false)
////
////    deinit {
////        assert(slot == nil, "`slot != nil` on `dealloc`.")
////    }
////    var isClosed: Bool {
////        return adhoc_isClosed_store.state
////    }
////    func send(_ signal: T?) {
////        guard isClosed == false else {
////
////            return
////        }
////        guard let s = signal else {
////            adhoc_isClosed_store.state = true
////            // From now on, `receive` won't read from `slot` anymore.
////            slot = nil
////            for _ in 0..<1024 {
////                sendReadySema.signal()
////                sendDoneSema.signal()
////                recvReadySema.signal()
////                recvDoneSema.signal()
////            }
////            return
////        }
////        recvReadySema.wait()
////        slotLock.lock()
////        slot = s
////        slotLock.unlock()
////        sendReadySema.signal()
////        recvDoneSema.wait()
////        sendDoneSema.signal()
////    }
////    func receive() -> T? {
////        guard isClosed == false else {
//////            recvReadySema.signal()
//////            recvDoneSema.signal()
////            return nil
////        }
////        let r: T?
////        recvReadySema.signal()
////        sendReadySema.wait()
////        slotLock.lock()
////        r = slot
////        slot = nil
////        slotLock.unlock()
////        recvDoneSema.signal()
////        sendDoneSema.wait()
////        return r
////    }
////}
//
//final class PcoGCDChannel<T>: PcoChannel {
//    private let sendReadySema = DispatchSemaphore(value: 0)
//    private let sendDoneSema = DispatchSemaphore(value: 0)
//    private let recvReadySema = DispatchSemaphore(value: 0)
//    private let recvDoneSema = DispatchSemaphore(value: 0)
//    private let slotLock = NSLock()
//    private var slot = T?.none
//    private let adhoc_isClosed_store = ADHOC_AtomicBool(false)
//
//    deinit {
//        assert(slot == nil, "`slot != nil` on `dealloc`.")
//    }
//    var isClosed: Bool {
//        return adhoc_isClosed_store.state
//    }
//    func send(_ signal: T?) {
//        guard isClosed == false else {
//
//            return
//        }
//        guard let s = signal else {
//            adhoc_isClosed_store.state = true
//            // From now on, `receive` won't read from `slot` anymore.
//            slot = nil
//            for _ in 0..<1024 {
//                sendReadySema.signal()
//                sendDoneSema.signal()
//                recvReadySema.signal()
//                recvDoneSema.signal()
//            }
//            return
//        }
//        recvReadySema.wait()
//        slotLock.lock()
//        slot = s
//        slotLock.unlock()
//        sendReadySema.signal()
//        recvDoneSema.wait()
//        sendDoneSema.signal()
//    }
//    func receive() -> T? {
//        guard isClosed == false else {
//            //            recvReadySema.signal()
//            //            recvDoneSema.signal()
//            return nil
//        }
//        let r: T?
//        recvReadySema.signal()
//        sendReadySema.wait()
//        slotLock.lock()
//        r = slot
//        slot = nil
//        slotLock.unlock()
//        recvDoneSema.signal()
//        sendDoneSema.wait()
//        return r
//    }
//}
//
//
////private let READY_TO_SEND = 0
////private let READY_TO_RECV = 1
////
////
////private let EMPTY = 0
////private let FULL = 2
////
////final class PcoGCDChannel<T>: PcoChannel {
////    private var slot = T?.none
////    private let phase = NSConditionLock(condition: EMPTY)
////    private let adhoc_isClosed_store = ADHOC_AtomicBool(false)
////
////    deinit {
////        assert(slot == nil, "`slot != nil` on `dealloc`.")
////    }
////    var isClosed: Bool {
////        return adhoc_isClosed_store.state
////    }
////    func send(_ signal: T?) {
////        guard isClosed == false else {
////            return
////        }
////        if signal == nil {
////            adhoc_isClosed_store.state = true
////        }
////        // Make sure that receving is done.
////        phase.lock(whenCondition: EMPTY)
////        slot = signal
////        phase.unlock(withCondition: FULL)
////    }
////    func receive() -> T? {
////        guard isClosed == false else {
////            let r: T?
////            if phase.tryLock(whenCondition: FULL) {
////                defer {
////                    slot = nil
////                    phase.unlock()
////                }
////                return slot
////            }
////            else {
////                return nil
////            }
////        }
////        let r: T?
////        phase.lock(whenCondition: FULL)
////        r = slot
////        slot = nil
////        phase.unlock(withCondition: EMPTY)
////        return r
////    }
////}
////
////extension NSLocking {
////    func runWithLock<U>(_ f: () -> U) -> U {
////        let r: U
////        lock()
////        r = f()
////        unlock()
////        return r
////    }
////}
//
//extension PcoGCDChannel: Sequence {
//    func makeIterator() -> AnyIterator<T> {
//        return AnyIterator { [weak self] () -> T? in
//            guard let ss = self else { return nil }
//            return ss.receive()
//        }
//    }
//}
