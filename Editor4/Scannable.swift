//
//  Scannable.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/25.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// Implementation of this protocol is rarely needed.
protocol Scannable {
    /// Scans current view state into UI state where needed and applicable.
    func scan()
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import AppKit

extension NSWindowController {
    func scanRecursively() {
        if let scannable = self as? Scannable {
            scannable.scan()
        }
        contentViewController?.scanRecursively()
    }
}
extension NSViewController {
    func scanRecursively() {
        if let scannable = self as? Scannable {
            scannable.scan()
        }
        for child in childViewControllers {
            child.scanRecursively()
        }
    }
}