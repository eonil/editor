////
////  TransactionFramework.swift
////  Editor6Common
////
////  Created by Hoon H. on 2017/03/10.
////  Copyright © 2017 Eonil. All rights reserved.
////

///
/// - Note:
///     Beware!
///     Each snapshot can contain some revision or timestamp. (or sign)
///     which works as a "salt" in cryptography. As a result, you cannot
///     reproduce same snapshot just be replaying operations in most
///     cases. You MUST replace your local state with `to` snapshot
///     to take proper revision-stamping.
///
public protocol TransactionProtocol {
    associatedtype Snapshot: SnapshotProtocol
    var from: Snapshot { get }
    var to: Snapshot { get }
    var by: [Snapshot.Operation] { get }
}
public protocol SnapshotProtocol {
    associatedtype Operation
//    ///
//    /// Two different snapshot with same `version` are
//    /// guaranteed to be equal.
//    /// Two different snapshot with different `version`s
//    /// can be equal or different. 
//    /// Which means, to be safe, you need to treat them
//    /// different, but they actually can be equal.
//    /// This can happen if they coincidently developed
//    /// equal values via different procedures.
//    ///
//    var version: Version { get }

    ///
    /// Apply a transaction.
    ///
    /// This simply replace `self` to supplied transaction's
    /// `to` snapshot. This is the only way to sync revision-
    /// stamp because snapshot reproduceability is not
    /// guaranteed.
    ///
    mutating func apply<T>(_: T) where T: TransactionProtocol, T.Snapshot == Self
}
extension SnapshotProtocol {
    mutating func apply<T>(_ m: T) where T: TransactionProtocol, T.Snapshot == Self {
        self = m.to
    }
}

public struct Common1Transaction<S: SnapshotProtocol>: TransactionProtocol {
    public var from: S
    public var to: S
    public var by: [S.Operation]
    public init(from: S, to: S, by: [S.Operation]) {
        self.from = from
        self.to = to
        self.by = by
    }
}
