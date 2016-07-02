//
//  NavigatorViewController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/07/02.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit
import EonilToolbox

private struct LocalState {
    var currentPaneID = NavigatorPaneID.files
}

final class NavigatorViewController: WorkspaceRenderableViewController {
    private let modeSelector = ToolButtonStripView()
    private let file = FileNavigatorViewController()
    private var local = LocalState()
    private var installer = ViewInstaller()

    override func render(state: UserInteractionState, workspace: (id: WorkspaceID, state: WorkspaceState)?) {
        local.currentPaneID = workspace?.state.window.navigatorPane.current ?? .files
        renderLocalState()
    }
    private func renderLocalState() {
        installer.installIfNeeded {
            view.wantsLayer = true
            view.layer?.backgroundColor = NSColor.redColor().CGColor

            addChildViewController(file)
            view.addSubview(modeSelector)
            view.addSubview(file.view)
        }
        let box = view.bounds.toBox().toSilentBox()
        let (contentBox, selectorBox) = box.splitInY(100%, 44)
        modeSelector.frame = selectorBox.toCGRect()
        file.view.frame = contentBox.toCGRect()
        print(file.view.constraints)
//        print(contentBox.toCGRect())
//        file.view.frame = CGRect(x: 0, y: 0, width: 900, height: 900)
    }
}
extension NavigatorViewController {
    override func viewDidLayout() {
        super.viewDidLayout()
        renderLocalState()
    }
}
