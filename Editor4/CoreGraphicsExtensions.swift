//
//  CoreGraphicsExtensions.swift
//  Editor4
//
//  Created by Hoon H. on 2016/06/28.
//  Copyright © 2016 Eonil. All rights reserved.
//

import CoreGraphics

extension CGSize {
    var rounding: CGSize {
        get {
            return CGSize(width: _round(width), height: _round(height))
        }
    }
    var ceiling: CGSize {
        get {
            return CGSize(width: _ceil(width), height: _ceil(height))
        }
    }
}

// MARK: -
private func _round(a: CGFloat) -> CGFloat {
    return round(a)
}
private func _ceil(v: CGFloat) -> CGFloat {
    return ceil(v)
}

