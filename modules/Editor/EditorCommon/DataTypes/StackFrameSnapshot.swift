//
//  StackFrameSnapshot.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

public struct StackFrameSnapshot {
    public var globals = [StackFrameVariable]()
    public var locals = [StackFrameVariable]()
}
public struct StackFrameVariable {
    public var name: String
    public var type: String
    public var value: Void
    public var expression: String
    public var subvariables = [StackFrameVariable]()
}
