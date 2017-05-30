////
////  DeferableStateContainer.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/22.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//
//enum DeferableStateContainerError: Error {
//    case missingContainer
//}
//final class DeferableStateContainer<State> {
//    private let origin: DeferredFlowOrigin
//    private var state: State
//    init(origin: DeferredFlowOrigin, state: State) {
//        self.origin = origin
//        self.state = state
//    }
//    func queueDeferredMutation<Result>(_ f: @escaping (State) -> (State, Result)) -> DeferredNotificationFlow<Result> {
//        return origin.spawnMutationFlow().mutate { [weak self] () throws -> (Result) in
//            guard let s = self else { throw DeferableStateContainerError.missingContainer }
//            let (s1, r) = f(s.state)
//            s.state = s1
//            return r
//        }
//    }
//}
