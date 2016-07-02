//
//  WorkspaceWindowController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox

private struct LocalState {
    var workspaceID: WorkspaceID?
}

final class WorkspaceWindowController: NSWindowController, DriverAccessible, WorkspaceRenderable {

    private let columnSplitViewController = NSSplitViewController()
    private let navigatorViewController = NavigatorViewController()
    private let rowSplitViewController = NSSplitViewController()
    private let dummy1ViewController = WorkspaceRenderableViewController()
    private var installer = ViewInstaller()
    private var localState = LocalState()

    ////////////////////////////////////////////////////////////////

    /// Designated initializer.
    init() {
        let newWindow = WorkspaceWindow()
        newWindow.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        newWindow.styleMask |= NSClosableWindowMask | NSResizableWindowMask | NSTitledWindowMask
        super.init(window: newWindow)
//        newWindow.display()
//        newWindow.makeKeyAndOrderFront(self)
//        let newWorkspaceViewController = WorkspaceViewController()
//        workspaceViewController = newWorkspaceViewController
//        contentViewController = newWorkspaceViewController
        shouldCloseDocument = false

        NotificationUtility.register(self, NSWindowWillCloseNotification, self.dynamicType.process)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationUtility.deregister(self)
    }

    ////////////////////////////////////////////////////////////////

    func render(state: UserInteractionState, workspace: (id: WorkspaceID, state: WorkspaceState)?) {
        renderLocalState()
        contentViewController?.renderRecursively(state, workspace: workspace)
    }
    private func renderLocalState() {
        installer.installIfNeeded {
//            assert(columnSplitViewController.view.autoresizesSubviews == false)
//            assert(rowSplitViewController.view.autoresizesSubviews == false)
            contentViewController = columnSplitViewController
            columnSplitViewController.view.autoresizesSubviews = false
            columnSplitViewController.splitViewItems = [
                NSSplitViewItem(contentListWithViewController: navigatorViewController),
                NSSplitViewItem(viewController: rowSplitViewController),
            ]
            rowSplitViewController.view.autoresizesSubviews = false
            rowSplitViewController.splitViewItems = [
                NSSplitViewItem(viewController: dummy1ViewController),
            ]
        }

        localState.workspaceID = localState.workspaceID
    }
    private func process(n: NSNotification) {
        switch n.name {
        case NSWindowWillCloseNotification:
            guard n.object === window else { return }
            guard let workspaceID = localState.workspaceID else { return }
            driver.operation.closeWorkspace(workspaceID)

        default:
            break
        }
    }
}

extension WorkspaceWindowController {
    override var shouldCloseDocument: Bool {
        willSet {
            assert(newValue == false)
        }
    }
}





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private final class WorkspaceWindow: NSWindow {
    override var canBecomeMainWindow: Bool {
        get {
            return true
        }
    }
}




















