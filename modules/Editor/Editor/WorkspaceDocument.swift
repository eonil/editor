//
//  Document.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Cocoa

class WorkspaceDocument: NSDocument {
    private let app = WorkspaceApp()

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    func process(_ id: MainMenuItemID) {
        app.process(id)
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
//        // Returns the Storyboard that contains your Document window.
//        let storyboard = NSStoryboard(name: "Main", bundle: nil)
//        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
//        self.addWindowController(windowController)
        addWindowController(app.rootWindowController)
    }
    override func read(from url: URL, ofType typeName: String) throws {
        app.features.process(.project(.relocate(to: url)))
    }


}
extension WorkspaceDocument {
    static var current: WorkspaceDocument? {
        let cdoc = NSDocumentController.shared.currentDocument
        return cdoc as? WorkspaceDocument
    }
}
