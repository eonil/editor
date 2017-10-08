//
//  functions.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

public func not(_ b: Bool) -> Bool {
    return !b
}

public func ignoreParameter<T>(_: T) -> Void {
}
//func toVoid<T>(_: T) -> Void {
//}

import Dispatch
public func toMainGCDQ<T>(_ f: @escaping (T) -> Void) -> ((T) -> Void) {
    return { v in DispatchQueue.main.async { f(v) } }
}

import Foundation
public func read(_ h: FileHandle) -> Data {
    // The data MUST be copied in current GCDQ.
    let d = h.availableData
    // And it can be passed to any GCDQ.
    return d
}
