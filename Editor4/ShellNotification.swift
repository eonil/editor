////
////  ShellNotification.swift
////  Editor4
////
////  Created by Hoon H. on 2016/05/25.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
///// A global notification in shell.
///// Strictly main-thread only.
///// Use this only when you HAVE TO route view component event to 
///// another view components **IMMEDIATELY** without any driver
///// loop latency.
/////
///// For now, the only usage is routing `NSMenuDelegate.menuNeedsUpdate`
///// message which must update views immediately.
//enum ShellNotification {
//    case FileNavigatorContextMenuWillOpen
//    case FileNavigatorContextMenuNeedsUpdate
//    case FileNavigatorContextMenuDidClose
//
//    func broadcast() {
//        for (_, invoke) in ShellNotification.mapping {
//            invoke(self)
//        }
//    }
//
//    private static var mapping = Dictionary<ObjectIdentifier, ShellNotification->()>()
//    static func register<T: AnyObject>(observer: T, _ handler: T -> ShellNotification -> ()) {
//        assertMainThread()
//        let invoke = { [weak observer] (n: ShellNotification) -> () in
//            guard let observer = observer else {
//                reportErrorToDevelopers("Pre-deallocation of an observer.")
//                fatalError()
//            }
//            handler(observer)(n)
//        }
//        mapping[ObjectIdentifier(observer)] = invoke
//    }
//    static func deregister<T: AnyObject>(observer: T) {
//        assertMainThread()
//        mapping[ObjectIdentifier(observer)] = nil
//    }
//}