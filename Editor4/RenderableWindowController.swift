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
/// Subclasses are responsible to filter out unwanted signals.
///
class RenderableWindowController: NSWindowController, Renderable {
    func render() {
    }
}
