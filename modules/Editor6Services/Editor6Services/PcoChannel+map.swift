//
//  PcoChannel+map.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

extension PcoIncomingChannel {
    ///
    /// Makes a new channel which maps incoming signal one-by-one to another type.
    ///
    /// Mapping will be performed in caller thread of `receive` function after received
    /// a signal.
    ///
    func map<U>(_ map: @escaping (Signal) -> (U)) -> PcoAnyIncomingChannel<U> {
        let ch1 = PcoMappedIncomingChannel<U>(underlyingChannel: self, map)
        let ch2 = PcoAnyIncomingChannel(ch1)
        return ch2
    }
}
extension PcoOutgoingChannel {
    ///
    /// Makes a new channel which maps outgoing signal one-by-one to another type.
    ///
    /// Mapping will be performed in caller thread of `send` function before sending
    /// a signal.
    ///
    func map<U>(_ map: @escaping (U) -> (Signal)) -> PcoAnyOutgoingChannel<U> {
        let ch1 = PcoMappedOutgoingChannel<U>(underlyingChannel: self, map)
        let ch2 = PcoAnyOutgoingChannel(ch1)
        return ch2
    }
}

private struct PcoMappedIncomingChannel<T>: PcoIncomingChannel {
    private let recvImpl: () -> (T?)
    private let mkitImpl: () -> AnyIterator<T>
    init<CH>(underlyingChannel: CH, _ map: @escaping (CH.Signal) -> (T)) where CH: PcoIncomingChannel {
        recvImpl = { underlyingChannel.receive().flatMap(map) }
        mkitImpl = { AnyIterator { underlyingChannel.makeIterator().next().flatMap(map) } }
    }
    func receive() -> T? {
        return recvImpl()
    }
    func makeIterator() -> AnyIterator<T> {
        return mkitImpl()
    }
}
private struct PcoMappedOutgoingChannel<T>: PcoOutgoingChannel {
    private let sendImpl: (T?) -> ()
    init<CH>(underlyingChannel: CH, _ map: @escaping (T) -> (CH.Signal)) where CH: PcoOutgoingChannel {
        sendImpl = { underlyingChannel.send($0.flatMap(map)) }
    }
    func send(_ signal: T?) {
        sendImpl(signal)
    }
}
