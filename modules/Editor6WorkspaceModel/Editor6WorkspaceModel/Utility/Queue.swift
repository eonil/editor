//
//  Queue.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/02.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

struct Queue<T> {
    private var buf = [T]()
    var isEmpty: Bool {
        return buf.isEmpty
    }
    mutating func enqueue(_ v: T) {
        buf.append(v)
    }
    mutating func dequeue() -> T? {
        if buf.isEmpty { return nil }
        return buf.removeFirst()
    }
}
