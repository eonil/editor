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
    private let recvImpl: (_ f: (T) -> ()) -> ()
    init<CH>(underlyingChannel: CH, _ map: @escaping (CH.Signal) -> T) where CH: PcoIncomingChannel {
        recvImpl = { f in
            underlyingChannel.receive(with: { (s: CH.Signal) in
                let derivedSignal = map(s)
                f(derivedSignal)
            })
        }
    }
    func receive(with handler: (T) -> ()) {
        recvImpl(handler)
    }
}
private struct PcoMappedOutgoingChannel<T>: PcoOutgoingChannel {
    private let sendImpl: (T) -> ()
    private let closeImpl: () -> ()
    init<CH>(underlyingChannel: CH, _ map: @escaping (T) -> CH.Signal) where CH: PcoOutgoingChannel {
        sendImpl = { underlyingChannel.send(map($0)) }
        closeImpl = { underlyingChannel.close() }
    }
    func send(_ signal: T) {
        sendImpl(signal)
    }
    func close() {
        closeImpl()
    }
}
