//
//  WorkspaceUIExtensions.swift
//  Editor6WorkspaceUI
//
//  Created by Hoon H. on 2016/10/15.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox

extension NSLayoutConstraint {
    func activateIgnorably() {
        isActive = true
        priority = NSLayoutPriorityRequired - 1
    }
}

extension CALayer {
    convenience init(backgroundColor: CGColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
}
extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let x = center.x - (size.width / 2)
        let y = center.y - (size.height / 2)
        self.origin = CGPoint(x: x, y: y)
        self.size = size
    }
    var midPoint: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    func resizedInY(by amount: CGFloat) -> CGRect {
        return CGRect(center: midPoint, size: size.added(height: amount))
    }
}
extension CGSize {
    func added(width addition: CGFloat) -> CGSize {
        return CGSize(width: width + addition, height: height)
    }
    func added(height addition: CGFloat) -> CGSize {
        return CGSize(width: width, height: height + addition)
    }
    func added(delta addition: CGVector) -> CGSize {
        return CGSize(width: width + addition.dx, height: height + addition.dy)
    }
    static func + (_ a: CGSize, _ b: CGVector) -> CGSize {
        return a.added(delta: b)
    }
}

extension CGFloat {
    mutating func minimize(_ a: CGFloat) {
        self = Swift.min(self, a)
    }
    mutating func maximize(_ a: CGFloat) {
        self = Swift.max(self, a)
    }
}
