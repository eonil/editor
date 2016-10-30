//
//  ModelMessageLoop.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

public final class WorkspaceModelMessageLoop {
    private typealias DispatchTransaction = (ModelTransaction<WorkspaceState>) -> ()
    private enum Phase {
        case none
        case processingTransactions
        case processingOperations
    }

    private var phase = Phase.none
    private var transactionQueue = [(DispatchTransaction) -> ()]()
    private var operationQuque = [ModelContinuation]()

    public func process(_ f: (ModelTransaction<WorkspaceState>) -> ()) {
        assert(Thread.isMainThread)
        assert(phase == .none)
        phase = .processingTransactions
        for t in transactionQueue {
            t(f)
        }
        transactionQueue = []
        phase = .processingOperations
        for op in operationQuque {
            op()
        }
        operationQuque = []
        phase = .none
    }

    fileprivate func process(_ n: WorkspaceNotification) {
        assert(Thread.isMainThread)
        assert(phase == .none)
        switch n {
        case .queue(let operation):
            assert(phase != .processingTransactions)
            operationQuque.append(operation)
        case .apply(let transaction):
            // Intentional closure wrapping to get trapped in LLDB.
            transactionQueue.append({ dispatch in dispatch(transaction) })
        }
    }
}

public extension WorkspaceModel {
    /// This weak-refs the loop.
    public func delegate(to loop: WorkspaceModelMessageLoop) {
        self.delegate { [weak loop] (n: WorkspaceNotification) in
            loop?.process(n)
        }
    }
}
