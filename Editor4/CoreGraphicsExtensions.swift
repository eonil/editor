//
//  CoreGraphicsExtensions.swift
//  Editor4
//
//  Created by Hoon H. on 2016/06/28.
//  Copyright © 2016 Eonil. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    func toTuple() -> (CGFloat, CGFloat) {
        return (x, y)
    }
}
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
    func toTuple() -> (CGFloat, CGFloat) {
        return (width, height)
    }
}
extension CGVector {
    func toTuple() -> (CGFloat, CGFloat) {
        return (dx, dy)
    }
}
func + (a: CGSize, b: CGSize) -> CGSize {
    return CGSize(width: a.width + b.width,
                  height: a.height + b.height)
}
func - (a: CGSize, b: CGSize) -> CGSize {
    return CGSize(width: a.width - b.width,
                  height: a.height - b.height)
}
func - (a: CGPoint, b: CGSize) -> CGPoint {
    return CGPoint(x: a.x - b.width,
                   y: a.y - b.height)
}
func * (a: CGSize, b: CGFloat) -> CGSize {
    return CGSize(width: a.width * b,
                  height: a.height * b)
}
func / (a: CGSize, b: CGFloat) -> CGSize {
    return CGSize(width: a.width / b,
                  height: a.height / b)
}

prefix func - (a: CGPoint) -> CGPoint {
    return CGPoint(x: -a.x,
                   y: -a.y)
}

extension CGRect {
    var minPoint: CGPoint {
        return CGPoint(x: minX,
                       y: minY)
    }
    var midPoint: CGPoint {
        return CGPoint(x: midX,
                       y: midY)
    }
    var maxPoint: CGPoint {
        return CGPoint(x: maxX,
                       y: maxY)
    }
}

// MARK: -
private func _round(a: CGFloat) -> CGFloat {
    return round(a)
}
private func _ceil(v: CGFloat) -> CGFloat {
    return ceil(v)
}

