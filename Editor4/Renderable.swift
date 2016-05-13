//
//  Renderable.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/10.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

/// Represents a renderable object.
protocol Renderable {
    func render()
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import AppKit

private struct RenderingStatistics {
    var viewControllerIterationCount = 0
    var renderingCallCount = 0
}
private var stat = RenderingStatistics()

extension NSWindowController {
    func renderRecursively() {
        // 1. Render first...
        if let renderable = self as? Renderable {
            renderable.render()
            stat.renderingCallCount += 1
        }
        // 2. ... and propagate next to reflect most recent state as early as possible.
        contentViewController?.renderRecursively()
        stat.viewControllerIterationCount += 1
        print("stat.viewControllerIterationCount: \(stat.viewControllerIterationCount)")
    }
}
extension NSViewController {
    func renderRecursively() {
        stat.viewControllerIterationCount += 1
        // 1. Render first...
        if let renderable = self as? Renderable {
            renderable.render()
            stat.renderingCallCount += 1
        }
        // 2. ... and propagate next to reflect most recent state as early as possible.
        for child in childViewControllers {
            child.renderRecursively()
        }
        stat.viewControllerIterationCount += 1
    }
}