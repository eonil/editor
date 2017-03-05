////
////  NotificationCenterExtensions.swift
////  Editor6
////
////  Created by Hoon H. on 2017/03/04.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import Foundation
//
//extension NotificationCenter {
//    func watch(_ n: Notification.Name, _ handler: (Notification) -> ())
//    func watch(_ n: RepoNotification, _ handler: (RepoNotification) -> ()) -> NotificationObserver<RepoNotification> {
//
//    }
//    func cast(_ n: RepoNotification) {
//
//    }
//}
//
//protocol NamedNotification {
//    static var uniqueTypeName: String { get }
//}
//extension NotificationCenter {
//    func watch<T>(_ handler: @escaping (T) -> ()) -> NotificationObserver<T> where T: NamedNotification {
//        let nn = NSNotification.Name(T.uniqueTypeName)
//        let rawObserver = addObserver(forName: nn, object: nil, queue: nil) { (n: Notification) in
//            guard let f = n.object as? (() -> T) else {
//                fatalError("Unexpected typed notification discovered. Expected `\(T.self)`, but it is `\(type(of: n))`.")
//            }
//            handler(f())
//        }
//        return NotificationObserver { [weak self, rawObserver] in
//            // We don't have to unregister the observer if
//            // the notification center has been deinitialized.
//            guard let ss = self else { return }
//            ss.removeObserver(rawObserver)
//        }
//    }
//    func broadcast<T>(_ notification: T) where T: NamedNotification {
//        let nn = Notification.Name(T.uniqueTypeName)
//        let c = { [notification] in return notification }
//        let n = Notification(name: nn, object: c, userInfo: nil)
//        post(n)
//    }
//}
//
//final class NotificationObserver<T> {
//    private let funcToCallOnDeinit: () -> ()
//    deinit {
//        funcToCallOnDeinit()
//    }
//    fileprivate init(_ onDeinit: @escaping () -> ()) {
//        funcToCallOnDeinit = onDeinit
//    }
//}
//
