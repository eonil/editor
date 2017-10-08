//
//  ClippingSeries.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/05.
//Copyright © 2017 Eonil. All rights reserved.
//

import EonilStateSeries

public struct ClippingSeries<Snapshot>: StateSeriesType {
    public typealias PointID = StateSeries<Snapshot>.PointID
    public typealias PointCollection = StateSeries<Snapshot>.PointCollection
    private let cap: Int
    private var core = Series<Snapshot>()
    
    public init(_ initialState: Snapshot, capacity: Int = 2) {
        precondition(capacity >= 1)
        cap = capacity
        core.append(initialState)
        clipToCapacity()
    }
    public var latest: Snapshot {
        return core.last!
    }
    public var points: PointCollection {
        return core.points
    }
    public mutating func append(_ state: Snapshot) {
        core.append(state)
        clipToCapacity()
    }
    public mutating func removeFirst(_ n: Int) {
        let n1 = n < core.count ? n : (core.count - 1)
        core.removeFirst(n1)
    }
    public mutating func clipToCapacity() {
        guard core.count > cap else { return }
        core.removeFirst(core.count - cap)
    }
}
