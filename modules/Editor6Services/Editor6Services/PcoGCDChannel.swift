//
//  GCDPcoChannel.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilGCDActor

final class PcoGCDChannel<T>: PcoChannel {
    fileprivate typealias CoreGCDChannel = GCDChannel<T>
    private let gcdch: CoreGCDChannel
    fileprivate let isClosedFlag = ADHOC_AtomicBool(false)

    fileprivate init(_ newGCDChannel: CoreGCDChannel) {
        gcdch = newGCDChannel
    }
    convenience init() {
        self.init(CoreGCDChannel())
    }
    deinit {
//        PcoReport.dispatch(.unclosedChannelOnDeinit(self))
    }

    var isClosed: Bool {
        return isClosedFlag.state
    }
    func send(_ signal: T) {
        gcdch.send(signal)
    }
    func receive() -> T {
        precondition(isClosed == false, "You're not allowed to `receive` from a closed channel.")
        let s = gcdch.receive()
        return s
    }
    func receive(with handler: (T) -> ()) {
        precondition(isClosed == false, "You're not allowed to `receive` from a closed channel.")
        while isClosedFlag.state == false {
            let s = gcdch.receive()
            handler(s)
        }
    }
    func close() {
        isClosedFlag.state = true
    }
}

//public final class PcoGCDIncomingChannel<T> {
//    fileprivate typealias CoreGCDChannel = GCDChannel<PcoIOChannelControlSignal<T>>
//    private let gcdch: CoreGCDChannel
//    fileprivate let isClosedFlag = ADHOC_AtomicBool(false)
//
//    fileprivate init(_ newGCDChannel: CoreGCDChannel) {
//        gcdch = newGCDChannel
//    }
//    public convenience init() {
//        self.init(CoreGCDChannel())
//    }
//    deinit {
//        assert(isClosedFlag.state == true)
//    }
//
//    var isClosed: Bool {
//        return isClosedFlag.state
//    }
//    //    var isAvailable: Bool {
//    //        return gcdch.isAvailable
//    //    }
//    //    func receive() -> T {
//    //        return gcdch.receive()
//    //    }
//    /// Blocks caller thread until channel closes.
//    ///
//    public func receive(with handler: (T) -> ()) {
//        while isClosedFlag.state {
//            let s = gcdch.receive()
//            switch s {
//            case .payload(let v):
//                handler(v)
//            case .close:
//                isClosedFlag.state = true
//            }
//        }
//    }
//    func reversed() -> PcoGCDOutgoingChannel<T> {
//        return PcoGCDOutgoingChannel(gcdch)
//    }
//}
//public final class PcoGCDOutgoingChannel<T> {
//    fileprivate typealias CoreGCDChannel = GCDChannel<PcoIOChannelControlSignal<T>>
//    private let gcdch: CoreGCDChannel
//    private let isClosedFlag = ADHOC_AtomicBool(false)
//
//    fileprivate init(_ newGCDChannel: CoreGCDChannel) {
//        gcdch = newGCDChannel
//    }
//    public convenience init() {
//        self.init(CoreGCDChannel())
//    }
//    deinit {
//        assert(isClosedFlag.state == true)
//    }
//    var isClosed: Bool {
//        return isClosedFlag.state
//    }
//    public func send(_ signal: T) {
//        gcdch.send(.payload(signal))
//    }
//    public func close() {
//        gcdch.send(.close)
//    }
//    func reversed() -> PcoGCDIncomingChannel<T> {
//        return PcoGCDIncomingChannel(gcdch)
//    }
//}

private enum PcoIOChannelControlSignal<T> {
    case payload(T)
    case close
}
