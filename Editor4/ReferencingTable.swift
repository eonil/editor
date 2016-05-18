//
//  ReferencingTable.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

struct ReferencingKey: Hashable {
    private var internalIndex: Int
    private init(internalIndex: Int) {
        self.internalIndex = internalIndex
    }
    var hashValue: Int {
        get { return internalIndex.hashValue }
    }
}
func ==(a: ReferencingKey, b: ReferencingKey) -> Bool {
    return a.internalIndex == b.internalIndex
}

struct ReferencingTableIndex<Element>: ForwardIndexType {
    private var allSlots: Array<Element?>
    private var internalIndex: Int
    func successor() -> ReferencingTableIndex {
        var copy = self
        while true {
            copy.internalIndex += 1
            if allSlots[copy.internalIndex] != nil { break }
            if copy.internalIndex == allSlots.endIndex { break } // End-index.
            if copy.internalIndex > allSlots.endIndex { fatalError("You cannot iterate over the end.") }
        }
        return copy
    }
    /// Makes an index for first non-free slot.
    private static func startIndexOf(table: ReferencingTable<Element>) -> ReferencingTableIndex {
        let newIndex = ReferencingTableIndex(allSlots: table.allSlots, internalIndex: table.allSlots.startIndex.predecessor())
        return newIndex.successor()
    }
    /// Makes an index for `allSlots.endIndex`.
    private static func endIndexOf(table: ReferencingTable<Element>) -> ReferencingTableIndex {
        return ReferencingTableIndex(allSlots: table.allSlots, internalIndex: table.allSlots.endIndex)
    }
}
func ==<Element>(a: ReferencingTableIndex<Element>, b: ReferencingTableIndex<Element>) -> Bool {
    return a.internalIndex == b.internalIndex
}

/// A dictionary which provides O(1) referencing time, but you cannot use arbitrary key.
///
/// Read by ref-key: strictly O(1).
/// Write can take up to O(n) due to internal array reallocation.
/// Anyway this reallocation happens only when `count` > `capacity`.
///
/// Take care about ref-key invalidation. If you use invalidated
/// ref-key, program will crash.
struct ReferencingTable<Element>: SequenceType {
    typealias Index = ReferencingTableIndex<Element>

    private var allSlots = Array<Element?>()
    private var freeSlotIndexStack = Array<Int>()

    /// O(1).
    var count: Int {
        get { return allSlots.count - freeSlotIndexStack.count }
    }
    var startIndex: Index {
        get { return Index.startIndexOf(self) }
    }
    var endIndex: Index {
        get { return Index.endIndexOf(self) }
    }
    /// O(1).
    func contains(referencingKey: ReferencingKey) -> Bool {
        return allSlots[referencingKey.internalIndex] != nil
    }
    /// O(1).
    /// If you're going to insert a new element, you must use `availbleReferencingKey`.
    /// - Parameter referencingKey:
    ///     Must be an existing key. You cannot use unknown key to insert a new element.
    subscript(referencingKey: ReferencingKey) -> Element {
        get {
            assert(freeSlotIndexStack.contains(referencingKey.internalIndex) == false)
            assert(contains(referencingKey))
            return allSlots[referencingKey.internalIndex]! // Crash for access with invalid key.
        }
        set {
            precondition(allSlots[referencingKey.internalIndex] != nil)
            allSlots[referencingKey.internalIndex]! = newValue // Crash for access with invalid key.
        }
    }
    mutating func insert(newElement: Element) -> ReferencingKey {
        if let emptySlotIndex = freeSlotIndexStack.popLast() {
            assert(allSlots[emptySlotIndex] == nil)
            allSlots[emptySlotIndex] = newElement
            return ReferencingKey(internalIndex: emptySlotIndex)
        }
        else {
            let newIndex = allSlots.count
            allSlots.append(newElement)
            return ReferencingKey(internalIndex: newIndex)
        }
    }
    mutating func remove(referencingKey: ReferencingKey) {
        assert(contains(referencingKey))
        assert(freeSlotIndexStack.contains(referencingKey.internalIndex) == false)
        allSlots[referencingKey.internalIndex] = nil
        freeSlotIndexStack.append(referencingKey.internalIndex)
    }
    func generate() -> AnyGenerator<(ReferencingKey, Element)> {
        var g = allSlots.entireRange.generate()
        var copy = allSlots
        return AnyGenerator {
            while true {
                if let next = g.next() {
                    if let element = copy[next] {
                        return (ReferencingKey(internalIndex: next), element)
                    }
                    else {
                        // Skip empty slots.
                        continue
                    }
                }
                else {
                    return nil
                }
            }
        }
    }
}





















