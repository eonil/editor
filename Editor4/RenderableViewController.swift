//
//  RenderableViewController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/10.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// Provides pre-configured to receive workspace rendering signals.
/// 
/// This class mainly exists to suppress request for NIB of `NSViewController`.
///
/// `render` method will be called for every action signals.
/// Subclass responsible to filter out unwanted signals.
///
class WorkspaceRenderableViewController: NSViewController, WorkspaceRenderable {
    override func loadView() {
        let v = NSView()
        self.view = v
    }
    func render(state: UserInteractionState, workspace: (id: WorkspaceID, state: WorkspaceState)?) {
        // No-op.
    }
}














