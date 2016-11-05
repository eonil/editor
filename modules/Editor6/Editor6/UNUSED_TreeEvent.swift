////
////  TreeEvent.swift
////  Editor6
////
////  Created by Hoon H. on 2016/10/10.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//
///// Assumes copying and gradual mutation is very cheap.
///// Sender is responsible to guarantee mutation integrity.
///// Mutated value from source value must be final value.
/////
/////     from + mutation == to
/////
///// Receiver can compare snapshot to validate transaction.
///// Snapshot equality is defined by each snapshot type,
///// and expected to be optimized by various methods.
/////
//struct Transaction<Snapshot, Mutation> {
//    var from: Snapshot
//    var mutation: Mutation
//    var to: Snapshot
//}
//
//typealias SetTransaction<T: Hashable> = Transaction<Set<T>, SetMutation<T>>
//typealias ArrayTransaction<T> = Transaction<Array<T>, ArrayMutation<T>>
//typealias DictionaryTransaction<K: Hashable, V> = Transaction<Dictionary<K,V>, DictionaryMutation<K,V>>
//
//enum SetMutation<Element: Hashable> {
//    case insert(Set<Element>)
//    case delete(Set<Element>)
//}
//enum ArrayMutation<Element> {
//    case insert([Element], in: Range<Int>)
//    case update([Element], in: Range<Int>)
//    case delete([Element], in: Range<Int>)
//}
//enum DictionaryMutation<Key: Hashable, Value> {
//    case insert([Key: Value])
//    case update([Key: Value])
//    case delete([Key])
//}
//
//extension Set {
//    mutating func apply(_ transaction: SetTransaction<Element>) {
//        self = transaction.to
//    }
//}
//
//extension Array {
//    mutating func apply(_ transaction: ArrayTransaction<Element>) {
//        self = transaction.to
//    }
//}
//
//extension Dictionary {
//    mutating func apply(_ transaction: DictionaryTransaction<Key, Value>) {
//        self = transaction.to
//    }
//}
//
//
//
//
//
//
//
//
//
//
