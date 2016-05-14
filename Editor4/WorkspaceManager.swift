//
//  WorkspaceManager.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/10.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// Manages workspaces and connected document and windows.
final class WorkspaceManager: DriverAccessible {

    private var latestWorkspaceKeysetVersion: Version?
    private var workspaceToWindowControllerMapping = [WorkspaceID: WorkspaceWindowController]()
    private var workspaceToDocumentMapping = [WorkspaceID: WorkspaceDocument]()

    var ADHOC_allWindows: LazyMapCollection<[WorkspaceID : WorkspaceWindowController], WorkspaceWindowController> {
        get { return workspaceToWindowControllerMapping.values }
    }

    ////////////////////////////////////////////////////////////////
    
//    init() {
//        Shell.register(self, self.dynamicType.render)
//    }
//    deinit {
//        Shell.deregister(self)
//    }

    ////////////////////////////////////////////////////////////////

    func render() {
        guard state.workspaces.version != latestWorkspaceKeysetVersion else { return }
        let (insertions, removings) = diff(Set(state.workspaces.keys), from: Set(workspaceToWindowControllerMapping.keys))
        insertions.forEach(openEmptyWorkspace)
        removings.forEach(closeWorkspace)
        assert(Set(state.workspaces.keys) == Set(workspaceToWindowControllerMapping.keys))

        for (_, wc) in workspaceToWindowControllerMapping {
            wc.renderRecursively()
        }
    }

    private func renderWorkspace(id: WorkspaceID, action: WorkspaceAction) {
        switch action {
        case .Open:
            openEmptyWorkspace(id)
//            guard let id = state.getWorkspaceForURL(u) else { return reportErrorToDevelopers("Cannot find newly added workspace for URL `\(u)`.") }
//            addDocumentFor(id)

        case .Close:
            closeWorkspace(id)
//            guard let id = state.getWorkspaceForURL(u) else { return reportErrorToDevelopers("Cannot find newly added workspace for URL `\(u)`.") }
//            addDocumentFor(id)

        case .Reconfigure(let location):
            reconfigureWorkspace(id, location: location)

        default:
            MARK_unimplemented()
        }
    }
    private func alertRecoverableError(error: ErrorType) {
        let cocoaError = error as NSError
        NSApplication.sharedApplication().presentError(cocoaError)
    }

    ////////////////////////////////////////////////////////////////

    private func openEmptyWorkspace(id: WorkspaceID) {
        let wc = WorkspaceWindowController()
        wc.workspaceID = id
        wc.showWindow(self)
        workspaceToWindowControllerMapping[id] = wc
    }
    private func closeWorkspace(id: WorkspaceID) {
        workspaceToWindowControllerMapping[id] = nil
        if let doc = workspaceToDocumentMapping.removeValueForKey(id) {
            doc.saveDocument(self)
            NSDocumentController.sharedDocumentController().removeDocument(doc)
        }
    }
    private func reconfigureWorkspace(id: WorkspaceID, location: NSURL?) {
        assert(workspaceToWindowControllerMapping[id] != nil)
        guard let wc = workspaceToWindowControllerMapping[id] else { return }
        if let doc = wc.document as? NSDocument {
            checkAndReport(doc is WorkspaceDocument, "`WorkspaceWindowController.document` must be bound only to `WorkspaceDocument`.")
            assert(doc is WorkspaceDocument)
            NSDocumentController.sharedDocumentController().removeDocument(doc)
        }
        if let location = location {
            let doc = WorkspaceDocument()
            do {
                try doc.readFromURL(location, ofType: "WorkspaceDocument")
                NSDocumentController.sharedDocumentController().addDocument(doc)
                wc.document = doc
            }
            catch let error {
                alertRecoverableError(error)
            }
        }
    }

//    private func addDocumentFor(id: WorkspaceID) {
//        NSDocumentController.sharedDocumentController().newDocument(nil)
//        do {
//            let newDocument = try NSDocumentController.sharedDocumentController().makeUntitledDocumentOfType("WorkspaceDocument")
//            guard let newWorkspaceDocument = newDocument as? WorkspaceDocument else {
//                reportErrorToDevelopers("Cannot make a new `WorkspaceDocument`.")
//                return
//            }
//                newWorkspaceDocument.workspaceID = id
//            NSDocumentController.sharedDocumentController().addDocument(newWorkspaceDocument)
//            newWorkspaceDocument.makeWindowControllers()
//            newWorkspaceDocument.showWindows()
//        }
//        catch let error as NSError {
//            NSApplication.sharedApplication().presentError(error)
//        }
//    }
//    private func removeDocumentFor(id: WorkspaceID) {
//        guard let doc = workspaceToDocumentMapping[id] else { return }
//        NSDocumentController.sharedDocumentController().removeDocument(doc)
//        workspaceToDocumentMapping[id] = nil
//    }
}