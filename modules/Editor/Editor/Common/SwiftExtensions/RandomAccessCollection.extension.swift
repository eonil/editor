//
//  RandomAccessCollection.extension.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/08.
//Copyright © 2017 Eonil. All rights reserved.
//

extension RandomAccessCollection {
    func splitFirst() -> (Element, SubSequence) {
        precondition(count >= 1)
        let i = index(startIndex, offsetBy: +1)
        let a = self[startIndex]
        let b = self[i..<endIndex]
        return (a, b)
    }
    func splitLast() -> (SubSequence, Element) {
        precondition(count >= 1)
        let i = index(endIndex, offsetBy: -1)
        let a = self[startIndex..<i]
        let b = self[i]
        return (a, b)
    }
}
