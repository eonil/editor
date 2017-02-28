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
/// `WorkspaceDocument` actually serves as driver (or controller)
/// for a workspace.
///
@objc
final class WorkspaceDocument: NSDocument {
//    private let workspaceController = WorkspaceController()
//    private let workspaceView = WorkspaceUIWindowController()
//    private var viewState = WorkspaceUIState()
//
//    override init() {
//        super.init()
//        workspaceView.delegate { [weak self] in self?.process($0) }
//        Driver.queue(.initiate(getID()))
//    }
//    deinit {
//        Driver.queue(.terminate(getID()))
//        workspaceView.delegate(to: ignore)
//        debugLog("closed")
//    }
//
//    func process(message: DriverMessage) {
//        
//    }
//    private func getID() -> WorkspaceID {
//        return WorkspaceID.from(document: self)
//    }
//    private func process(_ workspaceAction: WorkspaceUIAction) {
//        switch workspaceAction {
//        case .close:
//            close()
//        }
//    }
//
//    override func makeWindowControllers() {
//        super.makeWindowControllers()
//        addWindowController(workspaceView)
//    }
//
//    override func read(from url: URL, ofType typeName: String) throws {
//        Swift.print(#function)
//    }
//    override func write(to url: URL, ofType typeName: String) throws {
//        Swift.print(#function)
//    }
//    override func data(ofType typeName: String) throws -> Data {
//        Swift.print(#function)
//        return Data()
//    }
//
//    @objc
//    @available(*,unavailable)
//    override func print(_ sender: Any?) {
//        super.print(sender)
//    }
}
