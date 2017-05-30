//
//  LineWriter.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2017/03/01.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

struct LineWriter {
    var buf = ""
    mutating func write(_ s: String, _ onLine: (String) -> ()) {
        for ch in s.characters {
            buf.append(ch)
            if ch == "\n" {
                onLine(buf)
                buf = ""
            }
        }
    }
}
