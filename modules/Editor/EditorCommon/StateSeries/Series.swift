//
//  Series.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/02.
//Copyright © 2017 Eonil. All rights reserved.
//

import EonilStateSeries

public typealias Series<T> = StateSeries<T>

extension Series: RandomAccessCollection {
    public init<S>(_ s: S) where S: Sequence, S.Element == Element {
        self = Series()
        append(contentsOf: s)
    }
    public var count: Int { return points.count }
    public var startIndex: Int { return points.startIndex }
    public var endIndex: Int { return points.endIndex }
    public subscript(position: Int) -> Snapshot { return points[position].state }
}
