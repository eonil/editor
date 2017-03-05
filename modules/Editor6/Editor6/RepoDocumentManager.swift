//
//  RepoDocumentManager.swift
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
final class RepoDocumentManager {
    private let repoDocNotiWatch = BroadcastWatch<RepoDocumentNotification>()
    private let watchForNSWindowDidBecomeMain = NotificationWatch(.NSWindowDidBecomeMain)
    private let watchForNSWindowDidResignMain = NotificationWatch(.NSWindowDidResignMain)
    private var knownOpenDocs = [RepoDocument]()
    private weak var lastKnownCurrentDocument = RepoDocument?.none
    var delegate: ((Event) -> ())?

    enum Event {
        case didAddDocument(RepoDocument)
        case willRemoveDocument(RepoDocument)
        case changeState(of: RepoDocument)
        case changeCurrentDocument
    }

    init() {
        repoDocNotiWatch.delegate = { [weak self] in self?.process(repoDocNoti: $0) }
        watchForNSWindowDidBecomeMain.delegate = { [weak self] in self?.process(appKitNotification: $0) }
        watchForNSWindowDidResignMain.delegate = { [weak self] in self?.process(appKitNotification: $0) }
    }

    private func process(repoDocNoti e: RepoDocumentNotification) {
        switch e {
        case .didInit(let doc):
            knownOpenDocs.append(doc)
            doc.repoController.delegate = { [weak self] in self?.process(repoControllerEvent: $0) }
            delegate?(.didAddDocument(doc))
        case .willDeinit(let doc):
            delegate?(.willRemoveDocument(doc))
            doc.repoController.delegate = nil
            knownOpenDocs.remove(doc)
        }
    }

    private func process(repoControllerEvent e: RepoController.Event) {
        switch e {
        case .stateChange:
            guard let w = NSApplication.shared().mainWindow else { return }
            NSDocumentController.shared().document(for: w)
        }
    }
    private func process(appKitNotification n: Notification) {
        switch n.name {
        case Notification.Name.NSWindowDidBecomeMain:
            scanCurrentRepoDocument()
        case Notification.Name.NSWindowDidResignMain:
            scanCurrentRepoDocument()
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
    ///     `RepoDocument` object has current main window.
    ///     `nil` if there's no current document.
    ///
    /// - Time Complexity:
    ///     O(1) at best.
    ///     O(n) at worst.
    ///
    func findCurrentRepoDocument() -> RepoDocument? {
        scanCurrentRepoDocument()
        return lastKnownCurrentDocument
    }
    private func scanCurrentRepoDocument() {
        let oldCurDoc = lastKnownCurrentDocument
        if let doc1 = lastKnownCurrentDocument {
            if doc1.editor6_isCurrentDocument() == false {
                lastKnownCurrentDocument = nil
            }
        }
        for doc2 in knownOpenDocs {
            if doc2.editor6_isCurrentDocument() {
                lastKnownCurrentDocument = doc2
            }
        }
        if oldCurDoc !== lastKnownCurrentDocument {
            delegate?(.changeCurrentDocument)
        }
    }
}
