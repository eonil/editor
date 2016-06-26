//
//  WorkspaceDocument.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/21.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// Represents Cocoa document for a workspace.
///
/// Cocoa document is designed to represent a file-system entry.
/// So this object does that too.
///
/// This document does not *own* and window controller, and can be
/// rebound to any window controller when required. And the binding
/// is managed by `Shell`.
final class WorkspaceDocument: NSDocument, DriverAccessible {

//    private let window = WorkspaceWindowController()

    var workspaceID: WorkspaceID? {
        didSet {
            driver.ADHOC_dispatchRenderingInvalidation()
        }
    }

    override init() {
        super.init()
    }
    deinit {

    }
//    override func makeWindowControllers() {
//        super.makeWindowControllers()
//        addWindowController(window)
//    }
    override func readFromURL(url: NSURL, ofType typeName: String) throws {
        // Don't call super-class implementation.
        debugPrint("READ FROM: \(url)")
    }
    func render(state: UserInteractionState) {

    }
}