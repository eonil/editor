////
////  WorkspaceDocument.swift
////  Editor6Services
////
////  Created by Hoon H. on 2017/06/15.
////  Copyright © 2017 Eonil. All rights reserved.
////
//
//import AppKit
//import EonilSignet
//import Editor6Common
//
//public final class WorkspaceDocument: NSDocument {
//    static let filePathExtension = "ee6ws1"
//    public let event = Relay<Event>()
//
//    override init() {
//        super.init()
//        DocumentService.default.addWorkspaceDocument(self)
//    }
//    deinit {
//        DocumentService.default.removeWorkspaceDocument(self)
//        debugLog("WorkspaceDocument `\(self)` deinit.")
//    }
//    var isCurrentDocument: Bool {
//        return shell.windowController.window?.isMainWindow ?? false
//    }
//    
////    override func makeWindowControllers() {
////        super.makeWindowControllers()
////        addWindowController(shell.windowController)
////    }
//
//    public override func read(from url: URL, ofType typeName: String) throws {
////        features.meta.setLocation(url)
//        event.cast(.didReadFrom(url))
//    }
//    public override func write(to url: URL, ofType typeName: String) throws {
//        debugLog(#function)
//        event.cast(.didWriteTo(url))
//    }
//    public override func data(ofType typeName: String) throws -> Data {
//        debugLog(#function)
//        return Data()
//    }
//}
//public extension WorkspaceDocument {
//    public enum Event {
//        case didReadFrom(URL)
//        case didWriteTo(URL)
//    }
//    enum InternalEvent {
//        case didInit(WorkspaceDocument)
//        case willDeinit(WorkspaceDocument)
//    }
//}
