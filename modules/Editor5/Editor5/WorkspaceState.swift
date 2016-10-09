//
//  WorkspaceState.swift
//  Editor5
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

/// `WorkspaceDocument` owns and manages this state,
/// and dispatches back to `Driver` so the driver can
/// aggregate states of all workspaces.
///
struct WorkspaceState {
    var rootURL = URL?.none
    var files = [WorkspaceFilePath]()
}

struct WorkspaceFilePath {
    var isFolder = false
    var names = [String]()
}
