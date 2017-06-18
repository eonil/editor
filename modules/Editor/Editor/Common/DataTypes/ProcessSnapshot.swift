//
//  ProcessSnapshot.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/15.
//  Copyright © 2017 Eonil. All rights reserved.
//

struct ProcessSnapshot {
    var threads = [ThreadSnapshot]()
}

struct ThreadSnapshot {
    var frames = [ThreadStackFrame]()
}
struct ThreadStackFrame {
    var functionName: String
}
