//
//  BroadcastWatch.swift
//  Editor6
//
//  Created by Hoon H. on 2017/03/05.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

protocol Broadcastable {
}
extension Broadcastable {
    func broadcast() {
        let id1 = ObjectIdentifier(Self.self)
        if let map2 = watchmap[id1] {
            for (_, f) in map2 {
                let f1 = f as! (Self) -> ()
                f1(self)
            }
        }
    }
}

final class BroadcastWatch<T: Broadcastable> {
    var delegate: ((T) -> ())?
    init() {
        let id1 = ObjectIdentifier(T.self)
        let id2 = ObjectIdentifier(self)
        let f = { [weak self] (_ e: T) -> () in self?.delegate?(e) }
        var map2 = watchmap[id1] ?? [:]
        map2[id2] = f
        watchmap[id1] = map2
    }
    deinit {
        let id1 = ObjectIdentifier(T.self)
        let id2 = ObjectIdentifier(self)
        var map2 = watchmap[id1] ?? [:]
        map2[id2] = nil
        watchmap[id1] = map2
    }
}

private var watchmap = [ObjectIdentifier: [ObjectIdentifier: Any]]()
