//
//  WorkspaceDocumentManager.swift
//  Editor6
//
//  Created by Hoon H. on 2017/03/05.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import AppKit

///
/// In AppKit, each `NSDocument`s are independently created and destroyed
/// and there's no existing facility to track thier creation and destruction
/// from other place. They seem to be intended to be independent islands.
///
/// This object is designed to track such creation and destruction of
/// those documents. This also tracks *current* document state.
///
final class WorkspaceDocumentManager {
    private let repoDocNotiWatch = BroadcastWatch<WorkspaceDocumentNotification>()
    private let watchForNSWindowDidBecomeMain = NotificationWatch(.NSWindowDidBecomeMain)
    private let watchForNSWindowDidResignMain = NotificationWatch(.NSWindowDidResignMain)
    private var knownOpenDocs = [WorkspaceDocument]()
    private weak var lastKnownCurrentDocument = WorkspaceDocument?.none
    var delegate: ((Event) -> ())?

    enum Event {
        case didAddDocument(WorkspaceDocument)
        case willRemoveDocument(WorkspaceDocument)
        case changeState(of: WorkspaceDocument)
        case changeCurrentDocument
    }

    init() {
        repoDocNotiWatch.delegate = { [weak self] in self?.process(repoDocNoti: $0) }
        watchForNSWindowDidBecomeMain.delegate = { [weak self] in self?.process(appKitNotification: $0) }
        watchForNSWindowDidResignMain.delegate = { [weak self] in self?.process(appKitNotification: $0) }
    }

    private func process(repoDocNoti e: WorkspaceDocumentNotification) {
        switch e {
        case .didInit(let doc):
            knownOpenDocs.append(doc)
            delegate?(.didAddDocument(doc))
        case .willDeinit(let doc):
            delegate?(.willRemoveDocument(doc))
            knownOpenDocs.remove(doc)
        }
    }

    private func process(appKitNotification n: Notification) {
        switch n.name {
        case Notification.Name.NSWindowDidBecomeMain:
            scanCurrentWorkspaceDocument()
        case Notification.Name.NSWindowDidResignMain:
            scanCurrentWorkspaceDocument()
        default:
            break
        }
    }
    ///
    /// Gets document which has current main window.
    ///
    /// Current document can be missing if there's no open document.
    ///
    /// - Returns:
    ///     `WorkspaceDocument` object has current main window.
    ///     `nil` if there's no current document.
    ///
    /// - Time Complexity:
    ///     O(1) at best.
    ///     O(n) at worst.
    ///
    func findCurrentWorkspaceDocument() -> WorkspaceDocument? {
        scanCurrentWorkspaceDocument()
        return lastKnownCurrentDocument
    }
    private func scanCurrentWorkspaceDocument() {
        let oldCurDoc = lastKnownCurrentDocument
        if let doc1 = lastKnownCurrentDocument {
            if doc1.isCurrentDocument == false {
                lastKnownCurrentDocument = nil
            }
        }
        for doc2 in knownOpenDocs {
            if doc2.isCurrentDocument {
                lastKnownCurrentDocument = doc2
            }
        }
        if oldCurDoc !== lastKnownCurrentDocument {
            delegate?(.changeCurrentDocument)
        }
    }
}
