//
//  AppKitExtensions.swift
//  Editor4
//
//  Created by Hoon H. on 2016/06/28.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit

prefix func - (a: NSEdgeInsets) -> NSEdgeInsets {
    return NSEdgeInsets(top: -a.top, left: -a.left, bottom: -a.bottom, right: -a.right)
}

extension NSEdgeInsets {
    func insetting(rect: NSRect) -> NSRect {
        let	rect1	=	CGRect(
            x	:	rect.origin.x + left,
            y	:	rect.origin.y + bottom,
            width	:	rect.width - (left + right),
            height	:	rect.height - (top + bottom))
        
        return	rect1
    }
}