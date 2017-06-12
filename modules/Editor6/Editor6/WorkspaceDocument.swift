//
//  WorkspaceDocument.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/08.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import Editor6Common
import Editor6Services
import Editor6Features
import Editor6WorkspaceUI
import Editor6Shell

/// Treat `NSDocument` methods and events as user input.
///
/// `WorkspaceDocument` actually serves as driver (or controller)
/// for a repository.
///
final class WorkspaceDocument: NSDocument {
    static let filePathExtension = "ee6repo1"

    weak var services: Services? {
        didSet {
            (services != nil ? startServices() : endServices())
        }
    }

    private let workspaceFeatures = AppWorkspaceFeatures()
    private let workspaceShell = AppWorkspaceShell()
    private var viewState = WorkspaceUIState()

    override init() {
        super.init()
        WorkspaceDocumentNotification.didInit(self).broadcast()
    }
    deinit {
        WorkspaceDocumentNotification.willDeinit(self).broadcast()
        debugLog("closed")
    }

    var isCurrentDocument: Bool {
        return workspaceShell.windowController.window?.isMainWindow ?? false
    }

    private func startServices() {

    }
    private func endServices() {
        
    }

    override func makeWindowControllers() {
        super.makeWindowControllers()
        addWindowController(workspaceShell.windowController)
    }

    override func read(from url: URL, ofType typeName: String) throws {
        workspaceFeatures.meta.setLocation(url)
    }
    override func write(to url: URL, ofType typeName: String) throws {
        Swift.print(#function)
    }
    override func data(ofType typeName: String) throws -> Data {
        Swift.print(#function)
        return Data()
    }

    @objc
    @available(*,unavailable)
    override func print(_ sender: Any?) {
        super.print(sender)
    }
}

enum WorkspaceDocumentNotification: Broadcastable {
    case didInit(WorkspaceDocument)
    case willDeinit(WorkspaceDocument)
}
