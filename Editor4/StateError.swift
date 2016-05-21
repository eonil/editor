//
//  StateError.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/01.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// If the update result is equal4
enum StateError: ErrorType {
    case RollbackByMissingPrerequisites
    case BadPath(FileNodePath)
}
