//
//  Command.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// Command defines a set of multi-stepping operations.
/// Dispatching a command triggers execution of a multi-stepping 
/// operation which might perform external I/O and dispatch
/// multiple `Action`s.
enum Command {
    case RunMainMenuItem(MainMenuCommand)
}