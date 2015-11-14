//
//  CoreGraphicsExtensions.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public extension CGRect {
	public var midPoint: CGPoint {
		get {
			return	CGPoint(x: midX, y: midY)
		}
	}
//	public var round: CGRect {
//		get {
//			return	CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//		}
//	}
}
public extension CGSize {
	public var ceil: CGSize {
		get {
			return	CGSize(width: _ceil(width), height: _ceil(height))
		}
	}
}
public extension NSEdgeInsets {
	public func insetRect(rect: CGRect) -> CGRect {
		let	rect1	=	CGRect(
			x	:	rect.origin.x + left,
			y	:	rect.origin.y + bottom,
			width	:	rect.width - (left + right),
			height	:	rect.height - (top + bottom))

		return	rect1
	}
}
public prefix func -(insets: NSEdgeInsets) -> NSEdgeInsets {
	return	NSEdgeInsets(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right)
}









private func _round(v: CGFloat) -> CGFloat {
	return	round(v)
}
private func _ceil(v: CGFloat) -> CGFloat {
	return	ceil(v)
}