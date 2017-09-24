//
//  NSColor.extension.swift
//  Editor
//
//  Created by Hoon H. on 2017/09/24.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

extension NSColor {
    func weaken() -> NSColor {
        let a = alphaComponent * 0.9
        return withAlphaComponent(a)
    }
}
