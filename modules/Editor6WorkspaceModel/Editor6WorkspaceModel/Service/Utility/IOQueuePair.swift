//
//  IOQueuePair.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/19.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

struct IOQueuePair {
    var readQueue: DispatchQueue
    var writeQueue: DispatchQueue

    static func makeDualSerialBackground() -> IOQueuePair {
        func makeSerialBackgroundGCDQ(label: String) -> DispatchQueue {
            return DispatchQueue(label: label,
                                 qos: .background,
                                 attributes: [],
                                 autoreleaseFrequency: .workItem,
                                 target: nil)
        }
        return IOQueuePair(readQueue: makeSerialBackgroundGCDQ(label: "IOQueuePair/ReadGCDQ"),
                           writeQueue: makeSerialBackgroundGCDQ(label: "IOQueuePair/WriteGCDQ"))
    }
    static var main: IOQueuePair {
        return IOQueuePair(readQueue: .main, writeQueue: .main)
    }
}
