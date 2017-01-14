//
//  PcoAnyChannel.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

public struct PcoAnyChannel<T>: PcoChannel {
    private let sendImpl: (T) -> ()
    private let recvImpl: ((T) -> ()) -> ()
    private let closeImpl: () -> ()
    public init<CH>(_ source: CH) where CH: PcoChannel, CH.Signal == T, CH.Signal == T {
        sendImpl = { source.send($0) }
        recvImpl = { f in
            source.receive { s in
                f(s)
            }
        }
        closeImpl = { source.close() }
    }
    public func receive(with handler: (T) -> ()) {
        recvImpl(handler)
    }
    public func send(_ signal: T) {
        sendImpl(signal)
    }
    public func close() {
        closeImpl()
    }
}
public struct PcoAnyIncomingChannel<T>: PcoIncomingChannel {
    private let recvImpl: ((T) -> ()) -> ()
    public init<CH>(_ source: CH) where CH: PcoIncomingChannel, CH.Signal == T {
        recvImpl = { f in
            source.receive { s in
                f(s)
            }
        }
    }
    public func receive(with handler: (T) -> ()) {
        recvImpl(handler)
    }
}
public struct PcoAnyOutgoingChannel<T>: PcoOutgoingChannel {
    private let sendImpl: (T) -> ()
    private let closeImpl: () -> ()
    public init<CH>(_ source: CH) where CH: PcoOutgoingChannel, CH.Signal == T {
        sendImpl = { source.send($0) }
        closeImpl = { source.close() }
    }
    public func send(_ signal: T) {
        sendImpl(signal)
    }
    public func close() {
        closeImpl()
    }
}
