//
//  PcoIOChannels.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilGCDActor

//public final class PcoIOChannelSet<Command,Event> {
//    let command: OutgoingChannel<Command>
//    let event: IncomingChannel<Event>
//    let error: IncomingChannel<Error>
//
//    init(_ command: OutgoingChannel<Command>, _ event: IncomingChannel<Event>, _ error: IncomingChannel<Error>) {
//        self.command = command
//        self.event = event
//        self.error = error
//    }
//    deinit {
//        assert(command.isClosedFlag.state == true)
//        assert(event.isClosedFlag.state == true)
//        assert(error.isClosedFlag.state == true)
//    }
//}
//public typealias ErrorneousPcoIOChannelSet<Incoming,Outgoing> = (command: OutgoingChannel<Incoming>, event: IncomingChannel<Outgoing>, error: IncomingChannel<Error>)
public typealias PcoIOChannelSet<Incoming,Outgoing> = (command: PcoAnyOutgoingChannel<Incoming>, event: PcoAnyIncomingChannel<Outgoing>)
