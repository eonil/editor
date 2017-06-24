//
//  WorkspaceApp.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

final class WorkspaceApp {
    private let features = WorkspaceFeatures()
    private let shell = WorkspaceShell()

    init() {
        shell.features = features
    }
    deinit {
        shell.features = nil
    }
    var rootWindowController: NSWindowController {
        return shell.windowController
    }
    func process(_ c: MainMenuItemID) {
        features.process(c)
    }
}
