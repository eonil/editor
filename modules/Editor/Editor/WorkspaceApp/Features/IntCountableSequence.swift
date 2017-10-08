//
//  IntCountableSequence.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/08.
//Copyright © 2017 Eonil. All rights reserved.
//

protocol IntCountableSequence: Sequence {
    var count: Int { get }
}

extension Set: IntCountableSequence {
}
extension Array: IntCountableSequence {
}
