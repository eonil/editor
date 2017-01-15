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
    private let recvImpl: () -> (T?)
    private let mkitImpl: () -> AnyIterator<T>
    init<CH>(underlyingChannel: CH, _ bufferedMap: @escaping (CH.Signal) -> ([T])) where CH: PcoIncomingChannel {
        var buf = [T]()
        let process = { (_ f: () -> CH.Signal?) -> T? in
            while buf.count == 0 {
                guard let s = f() else { return nil } // End of stream.
                let ds = bufferedMap(s)
                buf.append(contentsOf: ds)
            }
            return buf.removeFirst()
        }
        recvImpl = { process(underlyingChannel.receive) }
        mkitImpl = { AnyIterator { process(underlyingChannel.makeIterator().next) } }
    }
    func receive() -> T? {
        return recvImpl()
    }
    func makeIterator() -> AnyIterator<T> {
        return mkitImpl()
    }
}

private final class PcoBufferedOutgoingChannel<T>: PcoOutgoingChannel {
    private let sendImpl: (T?) -> ()
    init<CH>(underlyingChannel: CH, _ bufferedMap: @escaping (T) -> ([CH.Signal])) where CH: PcoOutgoingChannel {
        sendImpl = { s in
            if let s = s {
                for d in bufferedMap(s) {
                    underlyingChannel.send(d)
                }
            }
            else {
                underlyingChannel.send(nil)
            }
        }
    }
    func send(_ s: T?) {
        sendImpl(s)
    }
}
