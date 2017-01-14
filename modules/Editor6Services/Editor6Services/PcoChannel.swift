//
//  PcoChannel.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

public protocol PcoChannel: PcoIncomingChannel, PcoOutgoingChannel {
}
public protocol PcoIncomingChannel {
    associatedtype Signal
//    func receive() -> Signal
    func receive(with handler: (Signal) -> ())
}
public protocol PcoOutgoingChannel {
    associatedtype Signal
    func send(_: Signal) -> ()
    func close()
}
