//
//  ManualViewController.swift
//  ManualView
//
//  Created by Hoon H. on 2016/10/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// - Note:
///     This view-controller can be used for `NSWindow.contentViewController`.
open class ManualViewController: NSViewController {
    public final var manual_view: ManualView {
        return super.view as! ManualView
    }

    @objc
    @available(*,unavailable)
    open override var view: NSView {
        willSet {}
    }

    @objc
    @available(*,unavailable)
    open override func loadView() {
        super.view = ManualView()
    }
}
