//
//  NSOutlineView.extension.swift
//  Editor
//
//  Created by Hoon H. on 2017/10/02.
//Copyright © 2017 Eonil. All rights reserved.
//

import AppKit

extension NSOutlineView {
    var clickedItem: Any? {
        let i = clickedRow
        guard i != -1 else { return nil }
        return item(atRow: i)
    }
}
