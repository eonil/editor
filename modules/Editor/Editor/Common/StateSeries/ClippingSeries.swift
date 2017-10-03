//
//  ClippingSeries.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/05.
//Copyright © 2017 Eonil. All rights reserved.
//

import EonilStateSeries

struct ClippingSeries<Snapshot>: StateSeriesType {
    typealias PointID = StateSeries<Snapshot>.PointID
    typealias PointCollection = StateSeries<Snapshot>.PointCollection
    private let cap: Int
    private var core = Series<Snapshot>()
    
    init(_ initialState: Snapshot, capacity: Int = 2) {
        cap = capacity
        core.append(initialState)
        clipToCapacity()
    }
    var current: Snapshot {
        return core.last!
    }
    var points: PointCollection {
        return core.points
    }
    mutating func append(_ state: Snapshot) {
        core.append(state)
        clipToCapacity()
    }
    mutating func removeFirst(_ n: Int) {
        let n1 = n < core.count ? n : (core.count - 1)
        core.removeFirst(n1)
    }
    mutating func clipToCapacity() {
        guard core.count < cap else { return }
        core.removeFirst(cap - core.count)
    }
}
