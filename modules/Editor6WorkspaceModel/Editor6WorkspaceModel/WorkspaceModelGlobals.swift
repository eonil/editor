//
//  WorkspaceModelGlobals.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/31.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper

public extension WorkspaceModel {
    public static func initializeGlobals() {
        LLDBGlobals.initializeLLDBWrapper()
    }
    public static func terminateGlobals() {
        LLDBGlobals.terminateLLDBWrapper()
    }
}
