////
////  Broadcast.swift
////  Editor6WorkspaceModel
////
////  Created by Hoon H. on 2016/10/29.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//
//final class Broadcast<N> {
//    typealias Notification = N
//
//    func a() {
//    }
//}
//
////protocol Sender: class {
////    associatedtype Notification
////}
////protocol Receiver: class {
////}
////extension Receiver {
////    func watch<S:Sender>(sender: S, handler: (S.Notification) -> ()) {
////
////    }
////    func unwatch<S:Sender>(sender: S) {
////
////    }
////}
//
//
//public protocol ModelNode: class {
//    associatedtype Notification
//}
//internal extension ModelNode {
//    static func += (sender: Self, _ handler: (Notification) -> ()) {
//
//    }
//}
//
//
//final class Sender<N> {
//    typealias Notification = N
//    func dispatch(_ n: Notification) {
//
//    }
//}
//final class Receiver<N> {
//    func watch<S:Sender>(_ sender: S) where S.Notification == N {
//
//    }
//    func unwatch<S:Sender>(_ sender: S) where S.Notification == N {
//
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
