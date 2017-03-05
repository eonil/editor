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
import Editor6WorkspaceUI

/// Treat `NSDocument` methods and events as user input.
///
/// `RepoDocument` actually serves as driver (or controller)
/// for a repository.
///
@objc
final class RepoDocument: NSDocument {
    @nonobjc
    static let filePathExtension = "ee6repo1"
    @nonobjc
    let repoController = RepoController()
    @nonobjc
    private let wswc = WorkspaceUIWindowController()
    @nonobjc
    private var viewState = WorkspaceUIState()

    override init() {
        super.init()
        wswc.delegate = { [weak self] in self?.process(workspaceUIEvent: $0) }
        RepoDocumentNotification.didInit(self).broadcast()
    }
    deinit {
        RepoDocumentNotification.willDeinit(self).broadcast()
        debugLog("closed")
    }

    ///
    /// Check whether this document is current or not.
    ///
    /// - Returns:
    ///     `true` if this document owns current main `NSWindow`.
    ///     `false` otherwise.
    ///
    func editor6_isCurrentDocument() -> Bool {
        return wswc.window?.isMainWindow ?? false
    }

    func process(message: DriverMessage) {
        
    }
//    private func getID() -> WorkspaceID {
//        return WorkspaceID.from(document: self)
//    }
    private func process(workspaceUIEvent e: WorkspaceUIAction) {
        switch e {
        case .close:
            close()
        }
    }

    override func makeWindowControllers() {
        super.makeWindowControllers()
        addWindowController(wswc)
    }

    override func read(from url: URL, ofType typeName: String) throws {
        Swift.print(#function)
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

enum RepoDocumentNotification: Broadcastable {
    case didInit(RepoDocument)
    case willDeinit(RepoDocument)
}
