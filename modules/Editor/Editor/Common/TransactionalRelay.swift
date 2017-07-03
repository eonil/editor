////
////  TransactionalRelay.swift
////  Editor
////
////  Created by Hoon H. on 2017/06/27.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//
//public final class TransactionalRelay<Mutation> {
//    public typealias Transaction = [Mutation]
//    fileprivate let relayImpl = Relay<Transaction>()
//    public func castAtomicTransaction(_ f: (_ tx: inout Transaction) -> Void) {
//        var tx = Transaction()
//        f(&tx)
//        relayImpl.cast(tx)
//    }
//}
//
//public func += <M> (_ a: TransactionalRelay<M>, _ b: Relay<[M]>) {
//    a.relayImpl += b
//}
//
//public func -= <M> (_ a: TransactionalRelay<M>, _ b: Relay<[M]>) {
//    a.relayImpl -= b
//}
