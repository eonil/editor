//
//  IOQueuePair.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

struct IOQueuePair {
    var incoming: DispatchQueue
    var outgoing: DispatchQueue

    static func makeSingleSerialBackground() -> IOQueuePair {
        let serialQueue = makeSerialBackgroundGCDQ(label: "IOQueuePair.incoming")
        return IOQueuePair(incoming: serialQueue,
                           outgoing: serialQueue)
    }
    static func makeDualSerialBackground() -> IOQueuePair {
        return IOQueuePair(incoming: makeSerialBackgroundGCDQ(label: "IOQueuePair.incoming"),
                           outgoing: makeSerialBackgroundGCDQ(label: "IOQueuePair.outgoing"))
    }
    static var main: IOQueuePair {
        return IOQueuePair(incoming: .main, outgoing: .main)
    }
}

private func makeSerialBackgroundGCDQ(label: String) -> DispatchQueue {
    return DispatchQueue(label: label,
                         qos: .background,
                         attributes: [],
                         autoreleaseFrequency: .workItem,
                         target: nil)
}
