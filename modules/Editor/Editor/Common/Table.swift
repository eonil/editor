//
//  Table.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/27.
//Copyright © 2017 Eonil. All rights reserved.
//

///
/// EXPERIMENTAL
///
/// Table issues unique ID for all each rows.
/// Once issued ID won't be reused.
/// Due to the internal design, ID is actually
/// same with internal array's index.
/// Number of ID is limited.
///
/// NO INSERTION is allowed.
/// Only appending and deleting are allowed.
/// Deleting does not reclaim the freed memory.
/// The memory will remain there.
///
struct Table<Value> {
    typealias Key = Int
    private var offset = 0
    private var rows = [Value?]()
    private var deletedRowCount = 0

    /// O(1) always.
    var count: Int {
        return rows.count - deletedRowCount
    }
    /// O(1) always.
    subscript(_ id: Key) -> Value {
        get { return rows[id]! }
        set { rows[id]! = newValue }
    }
    subscript(_ idRange: Range<Key>) -> [Value] {
        var r = [Value]()

        for i in idRange.lowerBound..<idRange.upperBound {
            if let v = rows[i] {
                r.append(v)
            }
        }
        return r
    }
    /// O(1) at best.
    /// O(n) at worst.
    mutating func append(_ value: Value) -> Key {
        let id = rows.count + offset
        rows.append(value)
        return id
    }
    /// O(1) always.
    mutating func remove(at id: Key) {
        guard rows[id - offset] != nil else { return }
        rows[id - offset] = nil
        deletedRowCount += 1
    }
    /// O(n) always.
    mutating func removeAll() {
        for i in 0..<rows.count {
            rows[i] = nil
        }
        deletedRowCount = rows.count
    }
    mutating func removeFirst(_ n: Int) {
        precondition(n <= count)
        guard n < count else { return removeAll() }
        var c = 0
        for i in 0..<rows.count {
            guard rows[i] != nil else { continue }
            rows[i] = nil
            c += 1
            if c == n {
                break
            }
        }
        deletedRowCount += n
        offset += n
    }
}
