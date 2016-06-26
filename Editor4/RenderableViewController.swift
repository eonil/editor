//
//  RenderableViewController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/10.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// Provides pre-configured to receive Shell rendering signals.
/// 
/// This class mainly exists to suppress request for NIB of `NSViewController`.
///
/// `render` method will be called for every action signal.
/// Subclass responsible to filter out unwanted signals.
///
class RenderableViewController: NSViewController, Renderable {

//    @available(*,unavailable)
//    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        assert(nibNameOrNil == nil)
//        assert(nibBundleOrNil == nil)
//        checkAndReport(nibNameOrNil == nil, "Expected `nil` for `nibNameOrNil`, but it's `\(nibNameOrNil)`.")
//        checkAndReport(nibBundleOrNil == nil, "Expected `nil` for `nibBundleOrNil`, but it's `\(nibBundleOrNil)`.")
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//    @available(*,unavailable)
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    deinit {
//        Shell.deregister(self)
//    }

    ////////////////////////////////////////////////////////////////

    override func loadView() {
        let v = NSView()
        self.view = v
    }
    func render(state: UserInteractionState) {
        
    }
}

class WorkspaceRenderableViewController: NSViewController, WorkspaceRenderable {
    override func loadView() {
        let v = NSView()
        self.view = v
    }
    func render(state: UserInteractionState, workspace: (id: WorkspaceID, state: WorkspaceState)) {

    }
}

