//
//  AUDIT_unwrap.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

func AUDIT_unwrap<T>(_ v: @autoclosure () -> T?, _ message: String = "AUDIT_unwrap fail.") -> T {
    guard let v = v() else { preconditionFailure(message) }
    return v
}
