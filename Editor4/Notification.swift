//
//  Notification.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// Notification is usually notifies state mutation of a service
/// to the driver.
enum Notification {
    case Cargo(CargoNotification)
}

enum CargoNotification {
    case Step(CargoServiceState)
}