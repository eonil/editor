//
//  WorkspaceID.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

import EonilToolbox

struct WorkspaceID: Hashable {
    var hashValue: Int {
        get { return oid.hashValue }
    }
    private let oid = ObjectAddressID()
}
func == (a: WorkspaceID, b: WorkspaceID) -> Bool {
    return a.oid == b.oid
}

