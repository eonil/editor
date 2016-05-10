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

final class WorkspaceWindowController: NSWindowController, DriverAccessible {

    var workspaceID: WorkspaceID?
    private var installer = ViewInstaller()

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
        shouldCloseDocument = true

        NotificationUtility.register(self, NSWindowWillCloseNotification, self.dynamicType.process)
    }
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("IB/SB are unsupported.")
    }
    deinit {
        NotificationUtility.deregister(self)
    }

    ////////////////////////////////////////////////////////////////

    override var shouldCloseDocument: Bool {
        willSet {
            assert(newValue == true)
        }
    }

    func process(n: NSNotification) {
        switch n.name {
        case NSWindowWillCloseNotification:
            assert(workspaceID != nil)
            guard let workspaceID = workspaceID else { return }
            dispatch(Action.Workspace(id: workspaceID, command: WorkspaceAction.Close))

        default:
            break
        }
    }
    func render() {
        installer.installIfNeeded { 

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




















