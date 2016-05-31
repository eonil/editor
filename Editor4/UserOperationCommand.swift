//
//  UserOperationCommand.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// `UserOperationCommand` defines a set of multi-stepping operations.
/// Dispatching a command triggers execution of a multi-stepping 
/// operation which might perform external I/O and dispatch
/// multiple `Action`s.
enum UserOperationCommand {
    case RunMenuItem(MenuCommand)
    case UserInteraction(UserInteractionCommand)
}

enum UserInteractionCommand {
    /// Try renaming in platform file-system.
    /// If successful, rename corresponding file node in user-interaction state.
    /// If failed, nothing will be changed.
    case Rename(WorkspaceID, FileID2, newName: String)
}