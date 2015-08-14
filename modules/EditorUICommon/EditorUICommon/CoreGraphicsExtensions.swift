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