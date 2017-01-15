//
//  PcoIOChannels.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import EonilGCDActor

public typealias PcoIOChannelSet<Incoming,Outgoing> = (command: PcoAnyOutgoingChannel<Incoming>, event: PcoAnyIncomingChannel<Outgoing>)
