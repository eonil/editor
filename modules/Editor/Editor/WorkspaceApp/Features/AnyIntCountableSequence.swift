//
//  AnyIntCountableSequence.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/08.
//Copyright © 2017 Eonil. All rights reserved.
//

struct AnyIntCountableSequence<Element>: IntCountableSequence {
    private let makeIterImpl: () -> AnyIterator<Element>
    let count: Int
    init<S>(_ s: S) where S: IntCountableSequence, S.Element == Element {
        makeIterImpl = { AnyIterator(s.makeIterator()) }
        count = s.count
    }
    func makeIterator() -> AnyIterator<Element> {
        return makeIterImpl()
    }
}
