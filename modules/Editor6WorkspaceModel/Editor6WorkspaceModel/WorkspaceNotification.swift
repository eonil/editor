//
//  WorkspaceEvent.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

public enum WorkspaceNotification {
    /// Renewed whole state.
    case queue(ModelContinuation)
    case apply(ModelTransaction<WorkspaceState>)
}
