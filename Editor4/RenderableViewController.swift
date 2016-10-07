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
        let v = LayoutEventRoutingView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.onResizeEvent = { [weak self] in
            self?.viewDidLayoutSubviews()
        }
        super.view = v
    }
    func render(state: UserInteractionState, workspace: (id: WorkspaceID, state: WorkspaceState)?) {
        // No-op in this class.
    }
    /// Do not use this method. This method get called on bad timing
    /// such as `NSView.resizeWithOldSuperviewSize()`. If we layout something
    /// in the method, the method will loop infinitely due to unknown reason...
    /// I don't know why, but it just happen.
    @available(*,unavailable)
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    func viewDidLayoutSubviews() {
        // No-op.
    }
}

private final class LayoutEventRoutingView: NSView {
    var onResizeEvent: (()->())?
    @objc
    override func resizeSubviewsWithOldSize(oldSize: NSSize) {
        super.resizeSubviewsWithOldSize(oldSize)
        onResizeEvent?()
    }
}












