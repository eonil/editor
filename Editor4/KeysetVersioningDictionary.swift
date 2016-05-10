//
//  KeysetVersioningDictionary.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

/// A dictionary with automatic versioning for key-set.
///
/// `version` gets a new value for each key-set change, but not
/// for values.
///
/// Intentionally duplicates interface of `Dictionary<Key,Value>` to 
/// be a drop-in replacement of a `Dictionary`.
///
/// - Note:
///     Original intention was being a drop-in replacement for `Dictionary`
///     anyway, it's too much work to duplicate `Dictionary` interface, 
///     and seems nottaht much valuable because I think it is subject to 
///     change as Swift evolves. So I provides only a few set of methods.
///
public struct KeysetVersioningDictionary<Key: Hashable,Value>: SequenceType, DictionaryLiteralConvertible {

    public typealias Element = (Key, Value)
    public typealias Index = DictionaryIndex<Key, Value>
    public typealias Generator = DictionaryGenerator<Key,Value>

    private var internalDictionary: Dictionary<Key, Value>
    /// Current version.
    /// Becomes a different value after any mutation has been performed.
    public private(set) var version: Version

    ////////////////////////////////////////////////////////////////

    public init() {
        internalDictionary = Dictionary()
        version = Version()
    }
    public init(dictionaryLiteral elements: (Key, Value)...) {
        internalDictionary = Dictionary()
        for (k,v) in elements {
            internalDictionary[k] = v
        }
        version = Version()
    }

    ////////////////////////////////////////////////////////////////

    public var count: Int {
        get { return internalDictionary.count }
    }
    public func generate() -> Generator {
        return internalDictionary.generate()
    }
    public subscript(key: Key) -> Value? {
        get { return internalDictionary[key] }
        set {
            // This must be an atomic operation.
            internalDictionary[key] = newValue
            version = Version()
        }
    }

    /// A collection containing just the keys of `self`.
    ///
    /// Keys appear in the same order as they occur as the `.0` member
    /// of key-value pairs in `self`.  Each key in the result has a
    /// unique value.
    public var keys: LazyMapCollection<[Key : Value], Key> {
        get { return internalDictionary.keys }
    }
    /// A collection containing just the values of `self`.
    ///
    /// Values appear in the same order as they occur as the `.1` member
    /// of key-value pairs in `self`.
    public var values: LazyMapCollection<[Key : Value], Value> {
        get { return internalDictionary.values }
    }
    /// `true` iff `count == 0`.
    public var isEmpty: Bool {
        get { return internalDictionary.isEmpty }
    }
}

public extension KeysetVersioningDictionary {
    public mutating func popFirst() -> (Key, Value)? {
        guard let popped = internalDictionary.popFirst() else { return nil }
        version = Version()
        return popped
    }
}


















