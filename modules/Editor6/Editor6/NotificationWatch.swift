//
//  NotificationWatch.swift
//  Editor6
//
//  Created by Hoon H. on 2017/03/04.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

final class NotificationWatch {
    var delegate = ((Notification) -> ())?.none
    let observerLifetime: AnyObject
    init(_ name: Notification.Name) {
        let nc = NotificationCenter.default
        var s: NotificationWatch?
        observerLifetime = nc.addObserver(forName: name, object: nil, queue: nil) { (n: Notification) in
            guard let ss = s else { return }
            ss.delegate?(n)
        }
        s = self
    }
}
