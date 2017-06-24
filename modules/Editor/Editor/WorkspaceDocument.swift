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

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
//        // Returns the Storyboard that contains your Document window.
//        let storyboard = NSStoryboard(name: "Main", bundle: nil)
//        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
//        self.addWindowController(windowController)
        addWindowController(app.rootWindowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }


}
extension WorkspaceDocument {
    static var current: WorkspaceDocument? {
        let cdoc = NSDocumentController.shared().currentDocument
        return cdoc as? WorkspaceDocument
    }
}
