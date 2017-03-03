//
//  debugLog.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/04.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

func debugLog(_ message: String) {
    print(message)
}
func debugLog<T>(_ value: T) {
    print("\(value)")
}
func debugLog<T: AnyObject>(withAddressOf object: T, message: String = "") {
    let id = ObjectIdentifier(object)
    let s = String(Int(bitPattern: id), radix: 16)
    debugLog("\(s): \(message)")
}
