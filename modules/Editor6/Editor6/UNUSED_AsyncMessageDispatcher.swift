////
////  AsyncMessageDispatcher.swift
////  Editor6
////
////  Created by Hoon H. on 2016/10/13.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//
///// A reentering-free message dispatcher.
/////
///// **THREAD SAFETY IS NOT YET IMPLEMENTED**
/////
///// You can en-queue message from any GCD queue or thread.
///// You can en-queue messages freely from any handlers. It won't trigger any re-entering.
///// You can dispatch queued messages at once later when you want.
///// You MUST dispatch queued messages OUT of handler. DO NOT dispatch queued messages
///// in handler. It will break everything.
/////
///// Why Do I Need This?
///// -------------------
///// Sending a message from a layer to another layer is hard due to re-entrancy.
///// If a message handler send another message, and if the message calls another handler
///// it can becomes an infinite loop easily.
/////
///// There's another problem. If each component of a system sends a message on their own
///// mutation, it's hard to guarantee state consistency of whole system. A message must 
///// be sent only when the state of overall system is consistent.
/////
///// The only way to avoid this is introducing asynchronicity.
///// To avoid reentering, accept messages and queue them until all handlers finishes
///// execution.
///// To avoid inconsistent state, collect messages until all mutations of a system to be
///// done, and send them at once.
/////
///// Because no new mutation message would come into the system, system will be kept
///// consistent.
/////
///// Extra checks (re-entering and executing GCDQ) are available to provide stronger guarantees.
/////
///// Assumptions
///// -----------
///// - Message sender can send only one type of message.
///// - Message receiver can have only one handler.
/////
//final class AsyncMessageDispatcher {
//    private struct MessageSourceCategory: Hashable {
//        var senderType: AnyObject.Type
//        var senderInstanceID: ObjectIdentifier
//        var hashValue: Int {
//            return senderInstanceID.hashValue
//        }
//        static func == (_ a: MessageSourceCategory, _ b: MessageSourceCategory) -> Bool {
//            return a.senderType == b.senderType
//                && a.senderInstanceID == b.senderInstanceID
//        }
//    }
//    private let gcdq: DispatchQueue
//    private var routingTable = [MessageSourceCategory: [ObjectIdentifier: (Any) -> ()]]()
//    private var msgQ = [(cat: MessageSourceCategory, content: Any)]()
//    init(executor: DispatchQueue) {
//        self.gcdq = executor
//    }
//    func dispatchAllNow() {
//        while msgQ.isEmpty == false {
//            let m = msgQ.removeFirst()
//            guard let receiverMapping = routingTable[m.cat] else { continue }
//            for (_, invoke) in receiverMapping {
//                invoke(m.content)
//            }
//        }
//    }
//    func queue<M, S: AnyObject>(message: M, from: S) {
//        let cat = MessageSourceCategory(senderType: S.self,
//                                        senderInstanceID: ObjectIdentifier(from))
//        msgQ.append((cat, message))
//    }
//    func register<Sender: AnyObject, Receiver: AnyObject, Message>(sender: Sender, receiver: Receiver, handler: @escaping (Message) -> ()) {
//        let invoke = { (message: Any) -> () in
//            guard let m1 = message as? Message else { fatalError() }
//            handler(m1)
//        }
//        let cat = MessageSourceCategory(senderType: Sender.self,
//                                        senderInstanceID: ObjectIdentifier(sender))
//        let receiverID = ObjectIdentifier(receiver)
//        routingTable[cat] = routingTable[cat] ?? [:]
//        routingTable[cat]?[receiverID] = invoke
//    }
//    func deregister<Sender: AnyObject, Receiver: AnyObject>(sender: Sender, receiver: Receiver) {
//        let cat = MessageSourceCategory(senderType: Sender.self,
//                                        senderInstanceID: ObjectIdentifier(sender))
//        let receiverID = ObjectIdentifier(receiver)
//        routingTable[cat]?[receiverID] = nil
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
