//
//  SignalQueue.swift
//  Editor6Features
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

struct SignalQueue<T> {
    private var buffer = [T]()
    mutating func queue(_ v: T) {
        buffer.append(v)
    }
    mutating func consume() -> T? {
        guard buffer.isEmpty == false else { return nil }
        return buffer.removeFirst()
    }
}
