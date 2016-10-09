//
//  WorkspaceUIWindowController.swift
//  Editor5
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox
import Editor5Common

final class WorkspaceUIWindowController: NSWindowController, NSWindowDelegate {
    var dispatch: ((WorkspaceUIAction) -> ())?
    private let workspaceViewController = WorkspaceUIViewController()
    private var installer = ViewInstaller()

    convenience init() {
        self.init(window: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("IB/SB are not supported.")
    }
    override init(window: NSWindow?) {
        super.init(window: window)
        self.window = window
        loadWindow()
        windowDidLoad()
    }

    func reload(_ newState: WorkspaceUIState) {
        contentViewController?.reload(newState, recursively: true)
    }

    private func render() {
        installer.installIfNeeded {
            guard let window = window else { reportFatalError() }
            window.styleMask.formUnion([.resizable, .miniaturizable, .closable, .titled])
            window.contentViewController = workspaceViewController
            window.setContentSize(NSSize(width: 500, height: 500))
            window.delegate = self
        }
    }

    override func loadWindow() {
        window = NSWindow()
    }
    override func windowDidLoad() {
        super.windowDidLoad()
        render()
    }
    func windowDidResize(_ notification: Notification) {
        render()
    }

    // MARK: -

    func windowWillClose(_ notification: Notification) {
        guard let d = document as? WorkspaceDocument else { reportFatalError() }
        d.close()
    }
}

fileprivate extension NSViewController {
    func reload(_ newState: WorkspaceUIState, recursively: Bool) {
        if let r = self as? WorkspaceUIRenderable {
            r.reload(newState)
        }
        if recursively {
            childViewControllers.forEach { cvc in
                cvc.reload(newState, recursively: true)
            }
        }
    }
}
