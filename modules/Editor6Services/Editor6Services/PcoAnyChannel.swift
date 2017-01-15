//
//  PcoAnyChannel.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

public struct PcoAnyChannel<T>: PcoChannel {
    private let sendImpl: (T?) -> ()
    private let recvImpl: () -> (T?)
    private let mkitImpl: () -> AnyIterator<T>
    public init<CH>(_ source: CH) where CH: PcoChannel, CH.Signal == T, CH.Signal == T {
        sendImpl = { source.send($0) }
        recvImpl = { source.receive() }
        mkitImpl = { source.makeIterator() }
    }
    public func receive() -> T? {
        return recvImpl()
    }
    public func send(_ signal: T?) {
        sendImpl(signal)
    }
    public func makeIterator() -> AnyIterator<T> {
        return mkitImpl()
    }
}
public struct PcoAnyIncomingChannel<T>: PcoIncomingChannel {
    private let recvImpl: () -> (T?)
    private let mkitImpl: () -> AnyIterator<T>
    public init<CH>(_ source: CH) where CH: PcoIncomingChannel, CH.Signal == T {
        recvImpl = { source.receive() }
        mkitImpl = { source.makeIterator() }
    }
    public func receive() -> T? {
        return recvImpl()
    }
    public func makeIterator() -> AnyIterator<T> {
        return mkitImpl()
    }
}
public struct PcoAnyOutgoingChannel<T>: PcoOutgoingChannel {
    private let sendImpl: (T?) -> ()
    public init<CH>(_ source: CH) where CH: PcoOutgoingChannel, CH.Signal == T {
        sendImpl = { source.send($0) }
    }
    public func send(_ signal: T?) {
        sendImpl(signal)
    }
}
