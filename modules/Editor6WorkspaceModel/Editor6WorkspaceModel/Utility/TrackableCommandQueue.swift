//
//  TrackableCommandQueue.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/21.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

final class TrackableCommandQueue<Command> {
    private var q = [() -> ()]()
    var count: Int {
        return q.count
    }
    func queue(command: Command, apply: @escaping (Command) -> ()) {
        q.append { apply(command) }
    }
    func processOne() {
        if q.count > 0 {
            q.removeFirst()()
        }
    }
    func processAll() {
        let q1 = q
        q = []
        for f in q1 {
            f()
        }
    }
}
