//
//  Shell.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit

struct Shell: DriverAccessible {

    private let mainMenu = MainMenuController()
    private var workspaceToUIMapping = [WorkspaceID: WorkspaceWindowController]()

    func render() {
        mainMenu.render()
        let (insertions, removings) = diff(Set(state.workspaces.keys), from: Set(workspaceToUIMapping.keys))
        guard let context = context else { return }
        switch context {
        case .Shell(let action):
            process(action)
        default:
            break
        }
    }
    private func process(action: ShellAction) {
        switch action {
        case .Quit:
            NSApplication.sharedApplication().terminate(nil)
        default:
            MARK_unimplemented()
        }
    }

}