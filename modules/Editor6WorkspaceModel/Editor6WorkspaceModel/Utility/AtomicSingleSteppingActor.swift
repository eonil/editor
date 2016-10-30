////
////  AtomicSingleSteppingActor.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/30.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//
//final class AtomicSingleSteppingActor<State> {
//    private var delegate: ((DebugNotification) -> ())?
//    private var local: State
//
//    init(state: State) {
//        local = state
//    }
//    func delegate(to newDelegate: @escaping (DebugNotification) -> ()) {
//        delegate = newDelegate
//    }
//    func queueSingleStepMutation<T>(_ f: @escaping (inout State) -> (T)) -> Future<T,DebugError> {
//        let f1 = Future<T,DebugError>()
//        delegate?(.queue({ [weak self] in
//            guard let s = self else {
//                f1.signal(.error(.missingSelf))
//            }
//            let r = s.mutate(f)
//            s.delegate?(.change(s.local.debugState))
//            f1.signal(.ok(r))
//        }))
//        return f1
//    }
//    private func mutate<T>(_ f: (inout State) -> (T)) -> (T) {
//        return f(&local)
//    }
//}


final class ModelDriver<State, Extras> {
    var state: State
    var extras: Extras
    init(state: State, extras: Extras) {
        self.state = state
        self.extras = extras
    }
}
