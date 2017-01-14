//
//  PcoChannel+bufferedMap.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

extension PcoIncomingChannel {
    ///
    /// Makes a new channel which maps incoming signal to another type 1:[0~n].
    ///
    /// Mapping will be performed in caller thread of `receive` function after received
    /// a signal.
    ///
    func bufferedMap<U>(_ bufferedMap: @escaping (Signal) -> ([U])) -> PcoAnyIncomingChannel<U> {
        let ch1 = PcoBufferedIncomingChannel(underlyingChannel: self, bufferedMap)
        let ch2 = PcoAnyIncomingChannel<U>(ch1)
        return ch2
    }
}
extension PcoOutgoingChannel {
    ///
    /// Makes a new channel which maps outgoing signal to another type 1:[0~n].
    ///
    /// Mapping will be performed in caller thread of `send` function before sending
    /// a signal.
    ///
    func bufferedMap<U>(_ bufferedMap: @escaping (U) -> ([Signal])) -> PcoAnyOutgoingChannel<U> {
        let ch1 = PcoBufferedOutgoingChannel(underlyingChannel: self, bufferedMap)
        let ch2 = PcoAnyOutgoingChannel<U>(ch1)
        return ch2
    }
}

private final class PcoBufferedIncomingChannel<T>: PcoIncomingChannel {
    private let recvImpl: ((T) -> ()) -> ()
    init<CH>(underlyingChannel: CH, _ bufferedMap: @escaping (CH.Signal) -> ([T])) where CH: PcoIncomingChannel {
        typealias S = CH.Signal
        recvImpl = { f in
            underlyingChannel.receive { (_ s: CH.Signal) in
                for d in bufferedMap(s) {
                    f(d)
                }
            }
        }
    }
    func receive(with handler: (T) -> ()) {
        recvImpl(handler)
    }
}

private final class PcoBufferedOutgoingChannel<T>: PcoOutgoingChannel {
    private let sendImpl: (T) -> ()
    private let closeImpl: () -> ()
    init<CH>(underlyingChannel: CH, _ bufferedMap: @escaping (T) -> ([CH.Signal])) where CH: PcoOutgoingChannel {
        sendImpl = { s in
            for d in bufferedMap(s) {
                underlyingChannel.send(d)
            }
        }
        closeImpl = {
            underlyingChannel.close()
        }
    }
    func send(_ s: T) {
        sendImpl(s)
    }
    func close() {
        closeImpl()
    }
}
