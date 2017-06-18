//
//  WorkspaceApp.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class WorkspaceApp {
    private let services = WorkspaceServices()
    private let features = WorkspaceFeatures()
    private let shell = WorkspaceShell()

    init() {
        features.services = services
        shell.features = features
    }
    deinit {
        features.services = nil
        shell.features = nil
    }
    var rootWindowController: NSWindowController {
        return shell.windowController
    }
}
