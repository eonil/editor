////
////  FiniteIncrementalList.swift
////  Editor
////
////  Created by Hoon H. on 2017/09/27.
////Copyright © 2017 Eonil. All rights reserved.
////
//
//struct FiniteIncrementalTable<V> {
//    typealias Key = Int
//    private(set) var items = [(key: Key, value: V)]()
//    private var seed = 0
//    var isOutOfKeySpace: Bool {
//        return seed == Int.max
//    }
//    mutating func append(contensOf values: [V]) {
//        for v in values { append(v) }
//    }
//    @discardableResult
//    mutating func append(_ value: V) -> Key {
//        precondition(isOutOfKeySpace == false)
//        let k = seed
//        items.append((k, value))
//        seed += 1
//        return k
//    }
//    mutating func replace(at index: Int, with value: V) {
//        items[index] = (items[index].key, value)
//    }
//    mutating func remove(at index: Int) {
//        items.remove(at: index)
//    }
//    mutating func removeAll() {
//        items = []
//    }
//    ///
//    /// Once issued keys won't be re-used.
//    /// Therefore you can run out of key space eventually.
//    /// In that case, you can call this method to reset
//    /// all keys in the list.
//    ///
//    mutating func compactKeySpace() {
//        for i in 0..<items.count {
//            items[i].key = i
//        }
//    }
//    func compactedKeySpace() -> FiniteIncrementalTable {
//        var copy = self
//        copy.compactKeySpace()
//        return copy
//    }
//}
//
