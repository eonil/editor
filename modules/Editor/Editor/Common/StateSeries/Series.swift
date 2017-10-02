//
//  Series.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/02.
//Copyright © 2017 Eonil. All rights reserved.
//

import EonilStateSeries

typealias Series<T> = StateSeries<T>

extension Series: RandomAccessCollection {
    public var count: Int { return points.count }
    public var startIndex: Int { return points.startIndex }
    public var endIndex: Int { return points.endIndex }
    public subscript(position: Int) -> Snapshot { return points[position].state }
}

extension Series: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Snapshot...) {
        self = Series()
        append(contentsOf: elements)
    }
}

//struct Series<Snapshot>: RandomAccessCollection, LazyCollectionProtocol {
//    typealias Point = StateSeries<Snapshot>.Point
//    private var ss = StateSeries<Snapshot>()
//    var count: Int { return ss.points.count }
//    var startIndex: Int { return ss.points.startIndex }
//    var endIndex: Int { return ss.points.endIndex }
//    subscript(position: Int) -> Point { return ss.points[position] }
//    mutating func append(_ s: Snapshot) {
//        ss.append(s)
//    }
//    mutating func append<S>(contentsOf s: S) where S: Sequence, S.Element == Snapshot {
//        s.forEach({ append($0) })
//    }
//    mutating func removeFirst(_ n: Int = 1) {
//        ss.removeFirst(n)
//    }
//}

