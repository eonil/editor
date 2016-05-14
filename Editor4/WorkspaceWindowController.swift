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

final class WorkspaceWindowController: RenderableWindowController, DriverAccessible {

    private let containerViewController = NSViewController()
    private let columnSplitViewController = NSSplitViewController()
    private let fileNavigatorViewController = FileNavigatorViewController()
    private let rowSplitViewController = NSSplitViewController()
    private var installer = ViewInstaller()

    ////////////////////////////////////////////////////////////////

    var workspaceID: WorkspaceID? {
        didSet {
            fileNavigatorViewController.workspaceID = workspaceID
        }
    }

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

    override var shouldCloseDocument: Bool {
        willSet {
            assert(newValue == false)
        }
    }

    private func process(n: NSNotification) {
        switch n.name {
        case NSWindowWillCloseNotification:
            assert(workspaceID != nil)
            guard let workspaceID = workspaceID else { return }
            dispatch(Action.Workspace(id: workspaceID, action: WorkspaceAction.Close))

        default:
            break
        }
    }
    override func render() {
        installer.installIfNeeded {
            contentViewController = columnSplitViewController
            columnSplitViewController.splitViewItems = [
                NSSplitViewItem(contentListWithViewController: fileNavigatorViewController),
                NSSplitViewItem(viewController: rowSplitViewController),
            ]
        }
    }

    ////////////////////////////////////////////////////////////////
    
}
extension WorkspaceWindowController {
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




















