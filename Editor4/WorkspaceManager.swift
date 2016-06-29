//
//  WorkspaceManager.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/10.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

private struct LocalState {
    var currentWorkspaceID: WorkspaceID?
}

/// Manages workspaces and connected document and windows.
final class WorkspaceManager: DriverAccessible {

    private var latestWorkspaceKeysetVersion: Version?
    private var workspaceWindowControllerMapping = [WorkspaceID: WorkspaceWindowController]()
    private var workspaceDocumentMapping = [WorkspaceID: WorkspaceDocument]()
    private var localState = LocalState()

    var ADHOC_allWindows: LazyMapCollection<[WorkspaceID : WorkspaceWindowController], WorkspaceWindowController> {
        get { return workspaceWindowControllerMapping.values }
    }

    ////////////////////////////////////////////////////////////////
    
    init() {
        NotificationUtility.register(self, NSWindowDidBecomeKeyNotification, self.dynamicType.process)
    }
    deinit {
        NotificationUtility.deregister(self)
    }

    ////////////////////////////////////////////////////////////////

    private func process(n: NSNotification) {
        switch n.name {
        case NSWindowDidBecomeKeyNotification:
//            guard let window = n.object as? NSWindow else { return }
//            for (id, wc) in workspaceWindowControllerMapping {
//                if wc.window === window {
//                    dispatch(.Workspace(id: id, action: .SetCurrent))
//                }
//            }
            scanCurrentWorkspace()

        default:
            break
        }
    }

    func scan() {
        for (_, wc) in workspaceWindowControllerMapping {
            wc.scanRecursively()
        }
    }
    func render(state: UserInteractionState) {
        guard state.workspaces.version != latestWorkspaceKeysetVersion else { return }

        // Download local state.
        localState.currentWorkspaceID = state.currentWorkspaceID

        // Render.

        let (insertions, removings) = diff(Set(state.workspaces.keys), from: Set(workspaceWindowControllerMapping.keys))
        insertions.forEach(openEmptyWorkspace)
        removings.forEach(closeWorkspace)
        assert(Set(state.workspaces.keys) == Set(workspaceWindowControllerMapping.keys))

        for (workspaceID, workspaceController) in workspaceWindowControllerMapping {
            func getWorkspace() -> (id: WorkspaceID, state: WorkspaceState)? {
                guard let workspaceState = state.workspaces[workspaceID] else { return nil }
                return (workspaceID, workspaceState)
            }
            let workspace = getWorkspace()
            workspaceController.render(state, workspace: workspace)
        }

        scanCurrentWorkspace()
    }
    private func alertRecoverableError(error: ErrorType) {
        let cocoaError = error as NSError
        NSApplication.sharedApplication().presentError(cocoaError)
    }

    ////////////////////////////////////////////////////////////////

    private func openEmptyWorkspace(id: WorkspaceID) {
        let wc = WorkspaceWindowController()
        wc.showWindow(self)
        workspaceWindowControllerMapping[id] = wc
    }
    private func closeWorkspace(id: WorkspaceID) {
        workspaceWindowControllerMapping[id] = nil
        if let doc = workspaceDocumentMapping.removeValueForKey(id) {
            doc.saveDocument(self)
            NSDocumentController.sharedDocumentController().removeDocument(doc)
        }
    }
    private func reconfigureWorkspace(id: WorkspaceID, location: NSURL?) {
        assert(workspaceWindowControllerMapping[id] != nil)
        guard let wc = workspaceWindowControllerMapping[id] else { return }
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
//        guard let doc = workspaceDocumentMapping[id] else { return }
//        NSDocumentController.sharedDocumentController().removeDocument(doc)
//        workspaceDocumentMapping[id] = nil
//    }

    private func scanCurrentWorkspace() {
        for (id, wc) in workspaceWindowControllerMapping {
            if wc.window?.mainWindow == true {
                if localState.currentWorkspaceID != id {
                    driver.operation.setCurrentWorkspace(id)
                    break
                }
            }
        }
    }
}

extension WorkspaceManager {
    
}





















