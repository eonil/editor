//
//  StateSeries.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/01.
//Copyright © 2017 Eonil. All rights reserved.
//

import EonilToolbox

struct StateSeries<Snapshot> {
    typealias Point = (id: PointID, state: Snapshot)
    let id = ObjectAddressID()
    private let pidm = PointIDManager()
    private(set) var points = [Point]()
    init() {
        
    }
    mutating func append(_ state: Snapshot) {
        let p = (PointID(), state)
        points.append(p)
    }
    mutating func append<S>(contentsOf states: S) where S: Sequence {
        states.forEach({ append($0) })
    }
}
extension StateSeries {
    struct PointID {
        static func issue
        private init() {
            
        }
        private final class PointIDManager {
            init() {
                
            }
        }
    }
}

struct StateSeriesPointID {
    
}


private final class SSImpl<T> {
    typealias PID = PIDImpl
    private var pidSeed = Int64(0)
    private var allIssuedPIDs = [(isAlive: Bool, PID)]()
    private func issuePointID() -> PID {
        pidSeed += 1
        let pid = PID(pidSeed) { [unowned self] in self.killPointID(pid) }
        allIssuedPIDs.insert((true, pid))
        return pid
    }
    private func killPointID(_ pid: PID) {
        
    }
    
    final class PIDImpl<T>: Comparable {
        var number: Int64
        var index: Int?
        init(_ n: Int64) {
            number = n
        }
    }

}


//private final class PointIDImpl {
//    static var allInstances = Set<InstanceRecord>()
//    struct InstanceRecord: Hashable {
//        unowned let ref: PointIDImpl
//        var hashValue: Int { return ObjectIdentifier(ref).hashValue }
//        static func == (_ a: InstanceRecord, _ b: InstanceRecord) -> Bool { return a.ref === b.ref }
//    }
//    init() {
//        PointIDImpl.allInstances.insert(InstanceRecord(ref: self))
//    }
//    deinit {
//        PointIDImpl.allInstances.remove(InstanceRecord(ref: self))
//    }
//}
//
//
//
//protocol StateSeriesType {
//    associatedtype ID: Equatable
//    associatedtype Snapshot: StatePointType
//    var id: ID { get }
//    var points: [Snapshot] { get }
//}
//
