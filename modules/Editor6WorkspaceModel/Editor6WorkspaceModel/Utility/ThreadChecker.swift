//
//  ThreadChecker.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/22.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

#if DEBUG
    /// Becomes no-memory, no-op on release build.
    struct ThreadChecker {
        private let threadID: pthread_t
        init() {
            threadID = pthread_self()
        }
        var isSameThread: Bool {
            return threadID == pthread_self()
        }
        func assertSameThread() {
            assert(isSameThread)
        }
    }
#else
    struct ThreadChecker {
        init() {}
        var isSameThread: Bool { return true }
        func assertSameThread() {}
    }
#endif
