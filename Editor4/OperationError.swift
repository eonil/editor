//
//  OperationError.swift
//  Editor4
//
//  Created by Hoon H. on 2016/06/29.
//  Copyright © 2016 Eonil. All rights reserved.
//

enum OperationError: ErrorType {
    case badFileURL(NSURL)
    case badUserInteractionState(UserInteractionError)

    case cannotResolveURLForWorkspaceFile(WorkspaceID, FileID2)

    case cannotMakeNameForNewFolder(WorkspaceID, container: FileID2)
}

