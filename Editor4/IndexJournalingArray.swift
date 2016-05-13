//
//  IndexJournalingArray.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/12.
//  Copyright © 2016 Eonil. All rights reserved.
//

private let DefaultJournalingCapacityLimit = 16

protocol IndexJournalingArrayType: VersioningStateType, CollectionType, SequenceType {
    var journal: IndexJournal { get }
}

/// A array which provides mutation history for small changes.
///
/// History is provided only for single element mutations. If you
/// perform multiple element mutation, history will be deleted.
/// History amount is limited, so overflown logs will be deleted.
struct IndexJournalingArray<Element>: IndexJournalingArrayType, ArrayLiteralConvertible {
    private var internalArray: Array<Element>
    private(set) var journal: IndexJournal
    private(set) var version = Version()

    ////////////////////////////////////////////////////////////////
    private mutating func logAndRevise(operation: ArrayIndexMutation) {
        let log = IndexJournal.Log(version: version, operation: operation)
        journal.append(log)
        version = Version()
    }
    private mutating func clearAllLogsAndRevise() {
        journal.removeAll()
        version = Version()
    }

    ////////////////////////////////////////////////////////////////
    init() {
        internalArray = []
        journal = IndexJournal(capacityLimit: DefaultJournalingCapacityLimit)
    }
    init(journalingCapacityLimit: Int) {
        internalArray = []
        journal = IndexJournal(capacityLimit: journalingCapacityLimit)
    }
    init(arrayLiteral elements: Element...) {
        internalArray = elements
        journal = IndexJournal(capacityLimit: DefaultJournalingCapacityLimit)
    }
    var count: Int {
        get { return internalArray.count }
    }
    func indexOf(predicate: (Element) throws -> Bool) rethrows -> Int? {
        return try internalArray.indexOf(predicate)
    }
    mutating func insert(newElement: Element, atIndex: Int) {
        internalArray.insert(newElement, atIndex: atIndex)
        logAndRevise(.Insert(atIndex))
    }
    mutating func append(newElement: Element) {
        let newIndex = count
        internalArray.append(newElement)
        logAndRevise(.Insert(newIndex))
    }
    mutating func removeAtIndex(index: Int) -> Element {
        let removed = internalArray.removeAtIndex(index)
        logAndRevise(.Delete(index))
        return removed
    }
    mutating func removeAll() {
        internalArray.removeAll()
        clearAllLogsAndRevise()
    }
}
extension IndexJournalingArray: CollectionType {
    var startIndex: Int {
        get { return internalArray.startIndex }
    }
    var endIndex: Int {
        get { return internalArray.endIndex }
    }
    subscript(index: Int) -> Element {
        get { return internalArray[index] }
        set {
            internalArray[index] = newValue
            logAndRevise(.Update(index))
        }
    }
}
extension IndexJournalingArray: SequenceType {
    typealias Generator = IndexingGenerator<Array<Element>>
    func generate() -> Generator {
        return internalArray.generate()
    }
}

/// A journal is a record of mutation
/// performed by `operation` on state of `version`
struct IndexJournal {
    typealias Log = (version: Version, operation: ArrayIndexMutation)
    let capacityLimit: Int
    /// All the log items must be sequential.
    private(set) var logs = Array<Log>()
    private init(capacityLimit: Int) {
        self.capacityLimit = capacityLimit
    }
    private mutating func append(log: Log) {
        while logs.count >= capacityLimit {
            logs.tryRemoveFirst()
        }
        logs.append(log)
    }
    private mutating func removeAll() {
        logs.removeAll()
    }
}

enum ArrayIndexMutation {
    case Insert(Int)
    case Update(Int)
    case Delete(Int)

    private func getIndex() -> Int {
        switch self {
        case .Insert(let index):    return index
        case .Update(let index):    return index
        case .Delete(let index):    return index
        }
    }
}












