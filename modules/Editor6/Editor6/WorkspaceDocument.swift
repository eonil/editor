//
//  WorkspaceDocument.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/08.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// Treat `NSDocument` methods and events as user input.
@objc
final class WorkspaceDocument: NSDocument {
    private let main = WorkspaceUIWindowController()
//    private let service = WorkspaceService()
    private var localState = WorkspaceState()

    override init() {
        super.init()
        Driver.dispatch(.initiate((getID(), localState)))
    }
    deinit {
        Driver.dispatch(.terminate((getID(), localState)))
        Swift.print("closed")
    }

    private func getID() -> WorkspaceID {
        return WorkspaceID.from(document: self)
    }

    override func makeWindowControllers() {
        super.makeWindowControllers()
        addWindowController(main)
        main.dispatch = { [weak self] in self?.process($0) }
    }

    private func process(_ workspaceAction: WorkspaceUIAction) {
//        switch workspaceAction {
//        }
    }

//    func process(command: WorkspaceCommand) {
//
//    }

    override func read(from url: URL, ofType typeName: String) throws {
        Swift.print(#function)
    }

    @objc
    @available(*,unavailable)
    override func print(_ sender: Any?) {
        super.print(sender)
    }
}
