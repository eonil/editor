//
//  AUDIT_check.swift
//  Editor6Common
//
//  Created by Hoon H. on 2017/05/28.
//  Copyright © 2017 Eonil. All rights reserved.
//

func AUDIT_check(_ condition: @autoclosure () -> Bool, _ message: String = "AUDIT_check fail.") {
    guard condition() else { reportFatalError(message) }
}