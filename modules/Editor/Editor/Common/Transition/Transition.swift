////
////  Transition.swift
////  Editor
////
////  Created by Hoon H. on 2017/09/29.
////Copyright © 2017 Eonil. All rights reserved.
////
//
/////
///// Idempotent state transition representation.
/////
//public struct Transition<Snapshot,Operation> where Snapshot: TransitionalSnapshot {
//    public var old: Snapshot
//    public var new: Snapshot
//    public var operation: Operation
//
//    public init(from old: Snapshot, to new: Snapshot, by operation: Operation) {
//        self.old = old
//        self.new = new
//        self.operation = operation
//    }
//}
//public extension Transition where Operation: AdditiveOperation  {
//    public static func + (_ a: Transition, _ b: Transition) -> Transition {
//        precondition(a.new.version == b.old.version, "Version mismatch!")
//        return Transition(from: a.from, to: b.to, operation: a.operation + b.operation)
//    }
//}
//public protocol AdditiveOperation {
//    static func + (_: Self, _: Self) -> Self
//}
//
//public enum SequenceRangeOperation {
//    case insert(Range<Int>)
//    case update(Range<Int>)
//    case delete(Range<Int>)
//}
//
//public enum HashKeyOperation<Key> where Key: Hashable {
//    case insert(Key)
//    case delete(Key)
//}
//
//public extension VersionedArray {
//    public typealias Transition = Transition<[Element], [SequenceRangeOperation]>
//}
////public extension VersionedSet {
////    public typealias Transition = Transition<[Element], [HashKeyOperation]>
////}
////public extension VersionedDictionary {
////    public typealias Transition = Transition<[Key], [HashKeyOperation]>
////}
//
