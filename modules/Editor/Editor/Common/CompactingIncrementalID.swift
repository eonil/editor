////
////  InfiniteIncrementalID.swift
////  Editor
////
////  Created by Hoon H. on 2017/09/25.
////Copyright © 2017 Eonil. All rights reserved.
////
//
//struct CompactingIncrementalID: Comparable {
//    private let node = NodeManager.shared.spawn()
//    static func < (_ a: InfiniteIncrementalID, _ b: InfiniteIncrementalID) -> Bool {
//        return a.node.number == b.node.number
//    }
//    static func == (_ a: InfiniteIncrementalID, _ b: InfiniteIncrementalID) -> Bool {
//        return a.node.number == b.node.number
//    }
//}
//
//private final class NodeManager {
//    static let shared = NodeManager()
//    let first = Node(0)
//    private(set) var last: Node
//    private var lastOfCompactedID: Node
//    init() {
//        last = first
//        lastOfCompactedID = last
//    }
//    func spawn() -> Node {
//        precondition(last.number < UInt64.max)
//        let n = Node(last.number + 1)
//        last.next = n
//        n.prior = last
//        if last === lastOfCompactedID {
//            lastOfCompactedID = n
//        }
//        last = n
//        return n
//    }
//    func kill(_ c: Node) {
//        if let p = c.prior {
//            if p.number < lastOfCompactedID.number {
//                lastOfCompactedID = p
//            }
//            p.next = c.next
//            p.compactNumberSpace(maximumOperationCount: 1)
//        }
//        c.next = nil
//        lastOfCompactedID = lastOfCompactedID.compactNumberSpace(maximumOperationCount: 16)
//    }
//}
//
//private final class Node {
//    var number: UInt64
//    var prior: Node?
//    var next: Node?
//    init(_ n: UInt64) {
//        number = n
//    }
//    ///
//    /// - Returns:
//    ///     Last node that are compacted.
//    ///
//    func compactNumberSpace(maximumOperationCount: UInt) -> Node {
//        guard maximumOperationCount > 0 else { return self }
//        guard let next = next else { return self }
//        next.number = number + 1
//        switch maximumOperationCount {
//        case 0:     return next
//        default:    return next.compactNumberSpace(maximumOperationCount: maximumOperationCount - 1)
//        }
//    }
//}

