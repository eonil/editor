//
//  AnyIntIndexingRandomAccessCollection.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/02.
//Copyright © 2017 Eonil. All rights reserved.
//

///
/// Basically same with `AnyRandomAccessCollection`, but uses
/// `Int` index and support naive index operations using
/// `Int` numbers as is.
/// Intended to be used just like an array.
///
///
/// This is semantically a copied snapshot of source collection.
///
struct AnyIntIndexingRandomAccessCollection<T>: RandomAccessCollection {
    private let subscriptImpl: (_ position: Int) -> T
    let startIndex: Int
    let endIndex: Int

    typealias Index = Int
    typealias Element = T

    init<C>(_ source: C) where C: RandomAccessCollection, C.Element == Element, C.Index == Index {
        subscriptImpl = { source[$0] }
        startIndex = source.startIndex
        endIndex = source.endIndex
    }
    subscript(position: Int) -> T {
        return subscriptImpl(position)
    }
}

extension RandomAccessCollection where Index == Int {
    func collectionTypeErased() -> AnyIntIndexingRandomAccessCollection<Element> {
        return AnyIntIndexingRandomAccessCollection(self)
    }
}

