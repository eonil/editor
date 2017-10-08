//
//  ProcessSnapshot.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

public struct ProcessSnapshot {
    public var threads = [ThreadSnapshot]()
}

public struct ThreadSnapshot {
    public var frames = [ThreadStackFrame]()
}
public struct ThreadStackFrame {
    public var functionName: String
}
