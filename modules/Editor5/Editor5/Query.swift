////
////  Query.swift
////  Editor5
////
////  Created by Hoon H. on 2016/10/08.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//
///// Query view state.
/////
///// Provides minimal, synchronous view statw query.
///// If we have 100% control over view components, this is not required.
///// AppKit does not provides such levle of control, and it's impossible
///// to track every state changes from view. Even with some event based 
///// tracking, it usually very hard to sync such state in proper timing.
/////
///// This provides a wrapper struct to query view states synchronously.
///// This exposes only minimal amount of informations.
/////
//struct Query {
//    var documentController: DocumentControllerQuery {
//        return DocumentControllerQuery()
//    }
//}
//
//struct DocumentControllerQuery {
//    fileprivate init() {
//    }
//    var currentWorkspaceDocument: WorkspaceDocumentQuery? {
//        return (NSDocumentController.shared().currentDocument as? WorkspaceDocument).flatMap(WorkspaceDocumentQuery.init)
//    }
//}
//
//struct WorkspaceDocumentQuery {
//    weak var source: WorkspaceDocument?
//    init?(source: WorkspaceDocument) {
//        self.source = source
//    }
//}
//
//struct WorkspaceQuery {
//
//}
//
/////// Some application state are owned by view objects.
/////// We don't have to copy such informations. Just provide
/////// some minified interface to query them.
////struct Query {
////    private unowned let source: Driver
////    init(source: Driver) {
////        self.source = source
////    }
////    var documentList: DocumentListQuery {
////        return DocumentListQuery()
////    }
////}
////
////struct ApplicationQuery {
////}
////
////struct DocumentListQuery {
////    init() {
////    }
////    var currentWorkspaceDocument: WorkspaceDocumentQuery? {
////        return WorkspaceDocumentQuery(source: NSDocumentController.shared().currentDocument as? WorkspaceDocument)
////    }
////}
////
////struct WorkspaceDocumentQuery {
////    let source: WorkspaceDocument
////    init?(source: WorkspaceDocument?) {
////        guard let source = source else { return nil }
////        self.source = source
////    }
////}
