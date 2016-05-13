//
//  RenderableWindowController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/11.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// Provides pre-configured to receive Shell rendering signals.
///
/// This class is intended to be subclassed.
/// `render` method will be called for every action signal.
/// Subclass responsible to filter out unwanted signals.
///
class RenderableWindowController: NSWindowController, Renderable {

//    override init(window: NSWindow?) {
//        super.init(window: window)
//        Shell.register(self)
//    }
//    @available(*,unavailable)
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    deinit {
//        Shell.deregister(self)
//    }

    ////////////////////////////////////////////////////////////////

    func render() {
    }
}
