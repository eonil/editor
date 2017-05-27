//
//  MutableChannel.batch.swift
//  Editor6Features
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import EonilSignet
import Editor6Common

extension MutableChannel {
    ///
    /// Perform multiple mutation and update only once
    /// so propagation happen only once at last.
    ///
    func mutateStateAtomically(_ f: (inout T) -> Void) {
        var editingState = state
        f(&editingState)
        state = editingState
    }
    ///
    /// Perform multiple updates transactionally.
    /// This is basically same with `mutateStateAtomically` except that
    /// this method will rollback any mutations on any error.
    ///
    func mutateStateTransactionally<E>(_ f: (T) -> Result<T,E>) -> Result<Void,E> {
        let r = f(state)
        switch r {
        case .failure(let issue):
            return .failure(issue)
        case .success(let solution):
            state = solution
            return .success(Void())
        }
    }
}
