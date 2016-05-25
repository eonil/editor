//
//  TemporalLazySequence.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// A sequence that is valid only at specific time range. For optimization.
///
/// This GUARANTEES the content of the sequence is immutable and won't be
/// changed later. Anyway, you can access elements only while
/// `version == accessibleVersion`.
///
struct TemporalLazySequence<Element>: SequenceType {
    private(set) var version: Version
    private var controller: TemporalLazySequenceController<Element>?
    var accessibleVersion: Version {
        get { return controller?.version ?? version }
    }
    /// Initializes an empty sequence.
    init() {
        self.version = emptySequenceVersion
        self.controller = nil
    }
    private init(controller: TemporalLazySequenceController<Element>) {
        self.version = controller.version
        self.controller = controller
    }
    var isEmpty: Bool {
        get { return generate().next() != nil }
    }
    func generate() -> AnyGenerator<Element> {
        precondition(version == accessibleVersion, "This sequence has been invalidated. You cannot access this now.")
        return controller?.source.generate() ?? AnyGenerator { return nil }
    }
}
//extension TemporalLazySequence: ArrayLiteralConvertible {
//    init(arrayLiteral elements: Element...) {
//        let c = TemporalLazySequenceController<Element>()
//        self.version = c.version
//        self.controller = c
//        c.source = AnySequence(elements)
//    }
//}

/// Performs all mutations here.
/// For each time you mutate, you'll get *conceptually* new sequence.
/// And old sequence gets invalidated, and shouldn't be accessed anymore.
final class TemporalLazySequenceController<T> {
    private(set) var sequence = TemporalLazySequence<T>()
    var version = Version()
    /// Setting a new source will invalidate any existing copies.
    var source: AnySequence<T> = AnySequence<T>([]) {
        didSet {
            version.revise()
            sequence = TemporalLazySequence(controller: self)
        }
    }
}

private let emptySequenceVersion = Version()



















