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
///
/// A channel can act as a onetime-use only sequence.
/// Once after you iterate over a channel, it become unusable and
/// any further trial to read from the channel will crash the program.
///
public protocol PcoIncomingChannel: Sequence {
    associatedtype Signal
    typealias Iterator = AnyIterator<Signal>
    ///
    /// - Returns:
    ///     A `Signal` value if everything is OK.
    ///     `nil` if channel has been closed.
    ///     In this case, this method returns immediately.
    ///
    func receive() -> Signal?
}
public protocol PcoOutgoingChannel {
    associatedtype Signal
    ///
    /// - Parameter signal:
    ///     A `Signal` value to send a value.
    ///     Or `nil` to close channel.
    ///     You SHOULD NEVER send non-nil value
    ///     after channel once has been closed.
    ///     It will crash the program.
    ///
    func send(_ signal: Signal?) -> ()
}
