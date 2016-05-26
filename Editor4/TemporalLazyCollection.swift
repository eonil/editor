//
//  TemporalLazyCollection.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// A collection that is valid only at specific time range. For optimization.
///
/// This GUARANTEES the content of the collection is immutable and won't be
/// changed later. Anyway, you can access elements only while
/// `version == accessibleVersion`.
///
struct TemporalLazyCollection<Element>: CollectionType {
    typealias Index = AnyRandomAccessIndex
//    typealias SubSequence = 
    private(set) var version: Version
    private var controller: TemporalLazyCollectionController<Element>?
    var accessibleVersion: Version {
        get { return controller?.version ?? version }
    }
    /// Initializes an empty sequence.
    init() {
        self.version = emptySequenceVersion
        self.controller = nil
    }
    init<C: CollectionType where C.Generator.Element == Element, C.Index: RandomAccessIndexType>(_ elements: C) {
        let c = TemporalLazyCollectionController<Element>()
        c.source = AnyRandomAccessCollection<Element>(elements)
        self.init(controller: c)
    }
    private init(controller: TemporalLazyCollectionController<Element>) {
        self.version = controller.version
        self.controller = controller
    }
    var isEmpty: Bool {
        get { return getSource().isEmpty }
    }
    func generate() -> AnyGenerator<Element> {
        return getSource().generate()
    }
    var startIndex: AnyRandomAccessIndex {
        get { return getSource().startIndex }
    }
    var endIndex: AnyRandomAccessIndex {
        get { return getSource().endIndex ?? AnyRandomAccessIndex(0) }
    }
    subscript(position: AnyRandomAccessIndex) -> Element {
        get { return getSource()[position] }
    }

    private func getSource() -> AnyRandomAccessCollection<Element> {
        // Shouldn't be broken even the controller is missing.
        assert(controller != nil, InvalidationErrorMessage)
        assert(version == accessibleVersion, InvalidationErrorMessage)
        return controller?.source ?? AnyRandomAccessCollection([])
    }
}
private let InvalidationErrorMessage = "This sequence has been invalidated. You cannot access this now."

extension TemporalLazyCollection: ArrayLiteralConvertible {
    init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

/// Performs all mutations here.
/// For each time you mutate, you'll get *conceptually* new sequence.
/// And old sequence gets invalidated, and shouldn't be accessed anymore.
final class TemporalLazyCollectionController<T> {
    private(set) var sequence = TemporalLazyCollection<T>()
    var version = Version()
    /// Setting a new source will invalidate any existing copies.
    var source: AnyRandomAccessCollection<T> = AnyRandomAccessCollection<T>([]) {
        didSet {
            version.revise()
            sequence = TemporalLazyCollection(controller: self)
        }
    }
}

private let emptySequenceVersion = Version()



















