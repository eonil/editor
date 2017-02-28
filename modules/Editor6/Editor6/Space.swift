//
//  Space.swift
//  Editor6
//
//  Created by Hoon H. on 2017/02/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import Editor6WorkspaceUI

final class Space {
    private var storage = State()
    private var workspacesUIWindowControllers = [WorkspaceUIWindowController]()
    init() {
    }
    deinit {
    }
    var state: State {
        get {
            return storage
        }
        set {
            storage = newValue
            render()
        }
    }
    private func render() {
    }
}
