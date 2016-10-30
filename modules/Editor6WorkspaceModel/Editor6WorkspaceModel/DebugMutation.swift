//
//  DebugMutation.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/29.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

public enum DebugMutation {
    case none
    case all(DebugState)
    case targets([DebugTargetID: DebugTargetState])
    case processes([DebugProcessID: DebugProcessState])
    case variables([DebugVariable])
}
