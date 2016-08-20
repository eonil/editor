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
            addChildViewController(file)
            view.addSubview(modeSelector)
            view.addSubview(file.view)
            func makeScopeButton(label: String) -> ScopeButton {
                let newButton = ScopeButton(title: label)
                newButton.titleFont = NSFont.systemFontOfSize(NSFont.systemFontSizeForControlSize(.SmallControlSize))
                return newButton
            }
            modeSelector.toolButtons = [
                makeScopeButton("File"),
                makeScopeButton("Issues"),
                makeScopeButton("Debug"),
                makeScopeButton("Logs"),
            ]
        }

        let box = view.bounds.toBox().toSilentBox()
        let (contentBox, selectorBox) = box.splitInY(100%, 32)
        modeSelector.frame = selectorBox.toCGRect()
        file.view.frame = contentBox.toCGRect()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        renderLocalState()
    }
}
//extension NavigatorViewController {
//    @objc
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        renderLocalState()
//        print("AAA")
//    }
//}



