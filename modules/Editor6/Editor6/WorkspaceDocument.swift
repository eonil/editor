//
//  WorkspaceDocument.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/08.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import Editor6WorkspaceModel
import Editor6WorkspaceUI

/// Treat `NSDocument` methods and events as user input.
@objc
final class WorkspaceDocument: NSDocument {
    private let model = WorkspaceModel()
    private let main = WorkspaceUIWindowController()
    private var localState = WorkspaceUIState()

    override init() {
        super.init()
        Driver.dispatch(.initiate(getID()))
    }
    deinit {
        Driver.dispatch(.terminate(getID()))
        Swift.print("closed")
    }

    func process(message: DriverMessage) {
        
    }

    private func getID() -> WorkspaceID {
        return WorkspaceID.from(document: self)
    }

    override func makeWindowControllers() {
        super.makeWindowControllers()
        addWindowController(main)
        main.delegate { [weak self] in
            self?.process($0)
        }
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
