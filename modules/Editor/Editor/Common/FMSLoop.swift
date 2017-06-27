////
////  FMSLoop.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/25.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//final class FSMLoop<S,M> where S: Equatable {
//    private let loop = ManualLoop()
//    private var fsm: FSM<S>
//    private(set) var q = [M]()
//    init(_ m: FSM<S>) {
//        fsm = m
//    }
//    var state: S {
//        return fsm.current
//    }
//    var step: ((M) -> Void)? {
//        get { return loop.step }
//        set { loop.step = newValue }
//    }
//    func queue(_ m: M) {
//        queue.append(m)
//        loop.signal()
//    }
//}
