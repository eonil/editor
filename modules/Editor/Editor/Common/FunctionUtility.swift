//
//  FunctionUtility.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/25.
//  Copyright © 2017 Eonil. All rights reserved.
//

/// Function related utilities.
struct FunctionUtility {
}

import Foundation
extension FunctionUtility {
    static func ignore<T>(_: T) {
    }
    static func makeReader() -> ((FileHandle) -> Data) {
        return { h in
            // The data MUST be copied in current GCDQ.
            let d = h.availableData
            // And it can be passed to any GCDQ.
            return d
        }
    }
    static func inMainGCDQ<T>(_ f: @escaping (T) -> Void) -> ((T) -> Void) {
        return { v in DispatchQueue.main.async { f(v) } }
    }
}

