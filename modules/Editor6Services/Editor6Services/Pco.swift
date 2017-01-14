//
//  Pco.swift
//  Editor6Services
//
//  Created by Hoon H. on 2017/01/14.
//  Copyright © 2017 Eonil. All rights reserved.
//

import EonilGCDActor

///
/// A collection of utility function for Pco.
///
/// Pco is an abbreviation for `Pseudo Coroutine`.
/// Pco provides a coroutine like concurrent execution
/// facility using system GCD. 
///
/// Originally intended name was `Process`, but it 
/// conflicts with `Foundation.Process`, and declined.
///
enum Pco {
    enum Panic {
        case error(Error)
    }
//    static func spawn(_ body: @escaping () -> ()) {
//        GCDActor.spawn { (_ ss: GCDActorSelf) in
//            body()
//        }
//    }
    ///
    /// Spawns a pco with pre-configured channels.
    /// 
    /// - Parameter body:
    ///     A function body.
    ///     You can throw an error only once.
    ///     Error throwing halts any on-going execution.
    ///     This function SHOULD NEVER return before the 
    ///     incoming/outgoing channels to be closed.
    ///
    /// - Note:
    ///     If you need to send multiple errors, it's more
    ///     likely to be a regular output signal rather
    ///     than an error. Consider making it as an output
    ///     signal intead of error.
    ///
    static func spawn<I,O>(panic: @escaping (Panic) -> (), _ body: @escaping (_ incoming: PcoAnyIncomingChannel<I>, _ outgoing: PcoAnyOutgoingChannel<O>) throws -> ()) -> PcoIOChannelSet<I,O> {
        let incoming = PcoGCDChannel<I>()
        let outgoing = PcoGCDChannel<O>()
        GCDActor.spawn({ (_ ss: GCDActorSelf) in
            do {
                try body(PcoAnyIncomingChannel(incoming), PcoAnyOutgoingChannel(outgoing))
            }
            catch let e {
                panic(.error(e))
            }
//            assert(incoming.isClosed == true, "Function `body` SHOULD NEVER be returned before `incoming` channel to be closed.")
//            assert(outgoing.isClosed == true, "Function `body` MUST close `outgoing` channel before return.")
        })
        return PcoIOChannelSet(PcoAnyOutgoingChannel(incoming), PcoAnyIncomingChannel(outgoing))
    }
    ///
    /// Same with another version of `spawn` except this 
    /// calls global panic handler on panic.
    ///
    static func spawn<I,O>(_ body: @escaping (_ incoming: PcoAnyIncomingChannel<I>, _ outgoing: PcoAnyOutgoingChannel<O>) throws -> ()) -> PcoIOChannelSet<I,O> {
        return spawn(panic: { Pco.panic($0) }, body)
    }
    ///
    /// Global panic handler.
    ///
    static var panic: ((Panic) -> ()) = { fatalError("Panic `\($0)` in a Pco.") }
}
