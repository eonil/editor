////
////  WorkspaceID.swift
////  Editor6
////
////  Created by Hoon H. on 2016/11/03.
////  Copyright © 2016 Eonil. All rights reserved.
////
//
//import Foundation
//
//struct WorkspaceID: Hashable {
//    private var oid: ObjectIdentifier
//    static func from(document: WorkspaceDocument) -> WorkspaceID {
//        return WorkspaceID(oid: ObjectIdentifier(document))
//    }
//    var hashValue: Int {
//        return oid.hashValue
//    }
//
//    static func == (_ a: WorkspaceID, _ b: WorkspaceID) -> Bool {
//        return a.oid == b.oid
//    }
//}
//
