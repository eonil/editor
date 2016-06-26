//
//  Renderable.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/10.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// Represents a renderable object.
protocol Renderable {
    func render(state: UserInteractionState)
}
protocol WorkspaceRenderable {
    func render(state: UserInteractionState, workspace: (id: WorkspaceID, state: WorkspaceState))
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
    func renderRecursively(state: UserInteractionState) {
        // 1. Render first...
        if let renderable = self as? Renderable {
            renderable.render(state)
            stat.renderingCallCount += 1
        }
        // 2. ... and propagate next to reflect most recent state as early as possible.
        contentViewController?.renderRecursively(state)
        stat.viewControllerIterationCount += 1
        print("stat.viewControllerIterationCount: \(stat.viewControllerIterationCount)")
    }
}
extension NSViewController {
    func renderRecursively(state: UserInteractionState) {
        stat.viewControllerIterationCount += 1
        // 1. Render first...
        if let renderable = self as? Renderable {
            renderable.render(state)
            stat.renderingCallCount += 1
        }
        // 2. ... and propagate next to reflect most recent state as early as possible.
        for child in childViewControllers {
            child.renderRecursively(state)
        }
        stat.viewControllerIterationCount += 1
    }
}


extension NSWindowController {
    func renderRecursively(state: UserInteractionState, workspace: (id: WorkspaceID, state: WorkspaceState)) {
        // 1. Render first...
        if let renderable = self as? WorkspaceRenderable {
            renderable.render(state, workspace: workspace)
            stat.renderingCallCount += 1
        }
        // 2. ... and propagate next to reflect most recent state as early as possible.
        contentViewController?.renderRecursively(state, workspace: workspace)
        stat.viewControllerIterationCount += 1
        print("stat.viewControllerIterationCount: \(stat.viewControllerIterationCount)")
    }
}
extension NSViewController {
    func renderRecursively(state: UserInteractionState, workspace: (id: WorkspaceID, state: WorkspaceState)) {
        stat.viewControllerIterationCount += 1
        // 1. Render first...
        if let renderable = self as? WorkspaceRenderable {
            renderable.render(state, workspace: workspace)
            stat.renderingCallCount += 1
        }
        // 2. ... and propagate next to reflect most recent state as early as possible.
        for child in childViewControllers {
            child.renderRecursively(state, workspace: workspace)
        }
        stat.viewControllerIterationCount += 1
    }
}
















