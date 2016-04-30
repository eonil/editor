//
//  Utility.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

func assertMainThread() {
    assert(NSThread.isMainThread())
}
func reportErrorToDevelopers(error: ErrorType) {

}
func reportErrorToDevelopers(error: String) {

}

extension Array {
    mutating func tryRemoveFirst() -> Element? {
        guard count > 0 else { return nil }
        return removeFirst()
    }
}
extension Dictionary {
        mutating func syncFrom<U>(anotherDictionary: Dictionary<Key,U>, instantiate: (Key,U)->Value) {
                let (insertions, removings) = diff(Set(keys), from: Set(anotherDictionary.keys)) // TODO: Optimise this.
                for k in removings {
                        self[k] = nil
                }
                for k in insertions {
                        let u = anotherDictionary[k]!
                        self[k] = instantiate(k,u)
                }
                assert(Set(keys) == Set(anotherDictionary.keys))
        }
}
func diff<T: Hashable>(a: Set<T>, from b: Set<T>) -> (insertions: Set<T>, removings: Set<T>) {
        let insertions = a.subtract(b)
        let removings = b.subtract(a)
        return (insertions, removings)
}
//func syncMapping<M0: KeyValueMapType, M1: KeyValueMapType where M0.KeyType == M1.KeyType, M0.ValueType == M1.ValueType>(inout a: M0, from b: M1, instantiate: ()->M0.ValueType) {
//        let (insertions, removings) = diff(Set(a.keys), from: Set(b.keys))
//        for k in
//}
//protocol KeyValueMapType {
//        associatedtype KeyType: Hashable
//        associatedtype ValueType
//        associatedtype KeySet: Hashable
//        var keys: key
//}

/// Instantiation produces different version value.
/// Copy produces equal version value.
struct Version: Hashable {
        var hashValue: Int {
                get { return ObjectIdentifier(dummy).hashValue }
        }
        private var dummy = NonObjectiveCBase()
}
func == (a: Version, b: Version) -> Bool {
        return a.dummy === b.dummy
}
protocol VersionedStateType {
        var version: Version { get }
}