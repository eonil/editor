//
//  KeyJournalingDictionary.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/13.
//  Copyright © 2016 Eonil. All rights reserved.
//

private let DefaultJournalingCapacityLimit = 16

/// - Note:
///     Interfaces are intentionally designed to be compatible with `Swift.Dictionary`.
///     Some members can be missing.
///
struct KeyJournalingDictionary<Key: Hashable, Value>: DictionaryLiteralConvertible, JournalingClearance {
    private var internalDictionary: Dictionary<Key,Value>
    private(set) var journal: KeyJournal<Key>
    private(set) var version = Version()

    ////////////////////////////////////////////////////////////////
    private mutating func logAndRevise(operation: KeyMutation<Key>) {
        let log = KeyJournal.Log(version: version, operation: operation)
        journal.append(log)
        version.revise()
    }
    private mutating func clearAllLogsAndRevise() {
        journal.removeAll()
        version.revise()
    }

    ////////////////////////////////////////////////////////////////
    init() {
        internalDictionary = [:]
        journal = KeyJournal(capacityLimit: DefaultJournalingCapacityLimit)
    }
    init(journalingCapacityLimit: Int) {
        internalDictionary = [:]
        journal = KeyJournal(capacityLimit: journalingCapacityLimit)
    }
    init(dictionaryLiteral elements: (Key, Value)...) {
        internalDictionary = [:]
        for (k,v) in elements {
            internalDictionary[k] = v
        }
        journal = KeyJournal(capacityLimit: DefaultJournalingCapacityLimit)
    }
    var count: Int {
        get { return internalDictionary.count }
    }
    var keys: LazyMapCollection<[Key : Value], Key> {
        get { return internalDictionary.keys }
    }
    var values: LazyMapCollection<[Key : Value], Value> {
        get { return internalDictionary.values }
    }
    var isEmpty: Bool {
        get { return internalDictionary.isEmpty }
    }
    subscript(key: Key) -> Value? {
        get { return internalDictionary[key] }
        set {
            if let newValue = newValue {
                if internalDictionary.updateValue(newValue, forKey: key) == nil {
                    // Newrly added.
                    internalDictionary[key] = newValue
                    logAndRevise(KeyMutation<Key>.Insert(key))
                    return
                }
                else {
                    // Updated in-place.
                    internalDictionary[key] = newValue
                    logAndRevise(KeyMutation<Key>.Update(key))
                    return
                }
            }
            else {
                if internalDictionary.removeValueForKey(key) == nil {
                    // No-op.
                    return
                }
                else {
                    // Removed.
                    internalDictionary[key] = newValue
                    logAndRevise(KeyMutation<Key>.Delete(key))
                    return
                }
            }
        }
    }
    mutating func removeValueForKey(key: Key) -> Value? {
        let r = internalDictionary.removeValueForKey(key)
        logAndRevise(KeyMutation<Key>.Delete(key))
        return r
    }
    mutating func clearJournal() {
        journal.removeAll()
    }
}
extension KeyJournalingDictionary: SequenceType {
    func generate() -> DictionaryGenerator<Key,Value> {
        return internalDictionary.generate()
    }
}




