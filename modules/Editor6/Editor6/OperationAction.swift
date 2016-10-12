//
//  OperationAction.swift
//  Editor6
//
//  Created by Hoon H. on 2016/10/10.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

enum OperationAction {
    case createWorkspace(URL)
    case openWorkspace(URL)
    case execute(WorkspaceCommand, on: WorkspaceID)
}
