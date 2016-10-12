//
//  WorkspaceID.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

struct WorkspaceID: Hashable {
    private weak var document: WorkspaceDocument?
    static func from(document: WorkspaceDocument) -> WorkspaceID {
        return WorkspaceID(document: document)
    }
    func getDocument() -> WorkspaceDocument {
        return document!
    }
    var hashValue: Int {
        return ObjectIdentifier(document!).hashValue
    }
}
func == (_ a: WorkspaceID, _ b: WorkspaceID) -> Bool {
    return a.getDocument() === b.getDocument()
}
