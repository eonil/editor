////
////  DocumentService.swift
////  Editor6Services
////
////  Created by Hoon H. on 2017/06/15.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import AppKit
//import EonilSignet
//
/////
///// Provides management of AppKit's `NSDocument`s.
/////
///// Mainly routes document events including init/deinit.
///// Due to AppKit's document nature, this is a singleton
///// object.
/////
//public final class DocumentService {
//    static let `default` = DocumentService()
//    public let event = Relay<Event>()
//    private let windowDidBecomeMainWatch = NotificationWatch(.NSWindowDidBecomeMain)
//    private let windowDidResignMainWatch = NotificationWatch(.NSWindowDidResignMain)
//    private var workspaceDocumentsWeakRefs = [ObjectIdentifier: () -> WorkspaceDocument?]()
//    private weak var lastKnownCurrentDocument = WorkspaceDocument?.none
//
//    init() {
//        windowDidBecomeMainWatch.delegate = { [weak self] in self?.processNotification($0) }
//        windowDidResignMainWatch.delegate = { [weak self] in self?.processNotification($0) }
//    }
//    deinit {
//        windowDidBecomeMainWatch.delegate = nil
//        windowDidResignMainWatch.delegate = nil
//    }
//    func addWorkspaceDocument(_ wd: WorkspaceDocument) {
//        workspaceDocumentsWeakRefs[ObjectIdentifier(wd)] = { [weak wd] in wd }
//    }
//    func removeWorkspaceDocument(_ wd: WorkspaceDocument) {
//        workspaceDocumentsWeakRefs[ObjectIdentifier(wd)] = nil
//    }
//
//
//    private func processNotification(_ n: Notification) {
//        switch n.name {
//        case Notification.Name.NSWindowDidBecomeMain:
//            scanCurrentWorkspaceDocument()
//        case Notification.Name.NSWindowDidResignMain:
//            scanCurrentWorkspaceDocument()
//        default:
//            break
//        }
//    }
//
//    ///
//    /// Gets document which has current main window.
//    ///
//    /// Current document can be missing if there's no open document.
//    ///
//    /// - Returns:
//    ///     `WorkspaceDocument` object has current main window.
//    ///     `nil` if there's no current document.
//    ///
//    /// - Time Complexity:
//    ///     O(1) at best.
//    ///     O(n) at worst.
//    ///
//    func findCurrentWorkspaceDocument() -> WorkspaceDocument? {
//        scanCurrentWorkspaceDocument()
//        return lastKnownCurrentDocument
//    }
//    private func scanCurrentWorkspaceDocument() {
//        let oldCurDoc = lastKnownCurrentDocument
//        if let doc1 = lastKnownCurrentDocument {
//            if doc1.isCurrentDocument == false {
//                lastKnownCurrentDocument = nil
//            }
//        }
//        for wdf in workspaceDocumentsWeakRefs.values {
//            guard let wd = wdf() else { continue }
//            if wd.isCurrentDocument {
//                lastKnownCurrentDocument = wd
//            }
//        }
//        if oldCurDoc !== lastKnownCurrentDocument {
//            event.cast(.didChangeCurrentDocument)
//        }
//    }
//}
//public extension DocumentService {
//    public enum Event {
//        case didChangeCurrentDocument
//    }
//}
