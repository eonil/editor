////
////  FSMLoop.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/25.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//final class FSMLoop<S,M> where S: Equatable {
//    private let loop = ManualLoop()
//    private var fsm: FSM<S>
//    private var q = [M]()
//    init(_ m: FSM<S>, _ stateSteppings: @escaping (S) -> (M) -> Void, _ validate: @escaping (S,M) -> Bool) {
//        fsm = m
//        loop.step = { [weak self] in
//            guard let ss = self else { return }
//            precondition(ss.q.count == 1)
//            let state = ss.fsm.current
//            let message = ss.q[0]
//            assert(validate(state, message))
//            let step = stateSteppings(state)
//            step(message)
//        }
//    }
//    var step: (() -> Void)? {
//        get { return loop.step }
//        set { loop.step = newValue }
//    }
//    func process(_ m: M) {
//        q.append(m)
//        loop.signal()
//    }
//}
//extension Equatable {
//    static func serial() -> FMSLoop {
//
//    }
//}
//
//
//protocol ActionProvisioning: Equatable {
//    associatedtype Message
//    func makeActions() -> [(Message) -> Void]
//}
////extension FSMLoop {
////    typealias Mapping = (S, [M])
////}
////protocol FSMLoopMessageMap {
////    var messagesForState(_ s: S) -> [M] {
////
////    }
////}
