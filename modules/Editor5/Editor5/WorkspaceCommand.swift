//
//  WorkspaceCommand.swift
//  Editor5
//
//  Created by Hoon H. on 2016/10/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

/// Commands that are accepted by `WorkspaceManager`.
enum WorkspaceCommand {
    case createFile(at: WorkspaceFilePath)
    case moveFile(from: WorkspaceFilePath, to: WorkspaceFilePath)
    case deleteFile(at: WorkspaceFilePath)
}
