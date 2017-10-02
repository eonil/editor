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
