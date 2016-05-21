//
//  QueryFlowService.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/21.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Dispatch
import BoltsSwift
import EonilToolbox

struct QueryID<T>: Hashable {
    private let internalID = ObjectAddressID()
    init() {
    }
    var hashValue: Int {
        get { return internalID.hashValue }
    }
}
func ==<T>(a: QueryID<T>, b: QueryID<T>) -> Bool {
    return a.internalID == b.internalID
}
//enum QueryAction {
//    case Test1ReturnsInt(QueryID<Int>)
//}
enum QueryError: ErrorType {
    case WaterTypeMismatch
}

/// An actor that manages query flows.
///
/// This runs in its own serial GCD queue.
///
/// How Query System Work?
/// ======================
/// 1. Make a new query ID.
/// 2. Send an action or operation with the ID.
/// 3. *Eventually*, system will produce a result for the ID.
/// 4. The result will be `post()`ed with the ID.
/// 5. That will compplete all waiting continuations with the result.
///
/// Query manager does not keep the query result. Query result 
/// continuation must be registered *before* the result comes out.
/// If the result does not comes up, waiter will stay there eternally.
///
final class QueryFlowService {
    private let gcdq = dispatch_queue_create("QueryFlowService Serial GCD Queue", DISPATCH_QUEUE_SERIAL)
    private var allWaiters = [ObjectAddressID: [AnyObject]]()
    func wait<T>(id: QueryID<T>) throws -> Task<T> {
        let waitCompletion = TaskCompletionSource<T>()
        dispatch_async(gcdq) { [weak self, waitCompletion] in
            guard let S = self else { return }
            if S.allWaiters[id.internalID] == nil {
                S.allWaiters[id.internalID] = []
            }
            S.allWaiters[id.internalID]!.append(waitCompletion)
        }
        return waitCompletion.task
    }
    /// - Returns:
    ///     A task that;
    ///     - completes if there's any waiters.
    ///     - cancels if there's no waiter.
    ///     - error for type mismatch.
    func dispatch<T>(result: T, to id: QueryID<T>) -> Task<()> {
        let callCompletion = TaskCompletionSource<()>()
        dispatch_async(gcdq) { [weak self, callCompletion] in
            guard let S = self else { return }
            guard let singleQueryWaiters = S.allWaiters[id.internalID] else {
                callCompletion.cancel()
                reportErrorToDevelopers("A result `\(result)` posted for id `\(id)` where no waiter.")
                return
            }
            for w in singleQueryWaiters {
                guard let waitCompletion = w as? TaskCompletionSource<T> else {
                    callCompletion.trySetError(QueryError.WaterTypeMismatch)
                    reportErrorToDevelopers("Some waiter is in wrong type.")
                    continue
                }
                waitCompletion.trySetResult(result)
            }
            S.allWaiters[id.internalID] = nil
            callCompletion.trySetResult(())
        }
        return callCompletion.task
    }
}
//extension Driver {
//    let query = QueryFlowService()
//}








