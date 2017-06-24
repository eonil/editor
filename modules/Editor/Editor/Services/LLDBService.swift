//
//  LLDBService.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper

///
/// Provides LLDB service.
///
/// - Note:
///     All the features of LLDB are provided
///     from LLDBWrapper library.
///     This object just provides a context.
///
final class LLDBService {
    private static var instanceCount = 0
    let debugger: LLDBDebugger
    init() {
        if LLDBService.instanceCount == 0 {
            LLDBGlobals.initializeLLDBWrapper()
        }
        LLDBService.instanceCount += 1
        debugger = LLDBDebugger()!
    }
    deinit {
        LLDBService.instanceCount -= 1
        if LLDBService.instanceCount == 0 {
            LLDBGlobals.terminateLLDBWrapper()
        }
    }
}
