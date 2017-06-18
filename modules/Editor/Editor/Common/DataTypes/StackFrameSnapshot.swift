//
//  StackFrameSnapshot.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

struct StackFrameSnapshot {
    var globals = [StackFrameVariable]()
    var locals = [StackFrameVariable]()
}
struct StackFrameVariable {
    var name: String
    var type: String
    var value: Void
    var expression: String
    var subvariables = [StackFrameVariable]()
}
