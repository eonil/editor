//
//  NotificationUtility.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/11.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

/// Provides simpler way to monitor `NSNotification`.
public struct NotificationUtility {
    private static var mapping = [ObjectIdentifier: AnyObject]()

    /// If another handler is already registered for the `identifier`
    /// it will be deregistered first.
    public static func register(identifier: ObjectIdentifier, _ name: String, _ handler: NSNotification -> ()) {
        if mapping[identifier] != nil {
            deregister(identifier)
        }
        let context = NSNotificationCenter.defaultCenter().addObserverForName(name, object: nil, queue: NSOperationQueue.mainQueue()) { handler($0) }
        mapping[identifier] = context
    }
    /// If no handler is registered for the `identifier` this call is no-op.
    public static func deregister(identifier: ObjectIdentifier) {
        guard let context = mapping[identifier] else { return }
        NSNotificationCenter.defaultCenter().removeObserver(context)
        mapping[identifier] = nil
    }
}
public extension NotificationUtility {
    public static func register<T: AnyObject>(observer: T, _ name: String, _ handler: T -> NSNotification -> ()) {
        register(ObjectIdentifier(observer), name) { [weak observer] (n :NSNotification) in
            guard let observer = observer else { fatalError("Captured `observer` has already been deallocated. This is not allowed.") }
            handler(observer)(n)
        }
    }
    public static func deregister<T: AnyObject>(observer: T) {
        deregister(ObjectIdentifier(observer))
    }
}