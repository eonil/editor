//
//  CodeRange.swift
//  Precompilation
//
//  Created by Hoon H. on 2015/01/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

public struct CodePoint {
	public init(lineNumber:Int, columnNumber:Int) {
		self.lineNumber		=	lineNumber
		self.columnNumber	=	columnNumber
	}
	public var	lineNumber:Int		///	1-based.
	public var	columnNumber:Int	///	1-based.
}

public struct CodeRange {
	public init(startPoint:CodePoint, endPoint:CodePoint) {
		self.startPoint	=	startPoint
		self.endPoint	=	endPoint
	}
	public var	startPoint:CodePoint
	public var	endPoint:CodePoint
}








extension CodePoint: Printable {
	public var description:String {
		get {
			return	"\(lineNumber):\(columnNumber)"
		}
	}
	public var lineIndex:Int {
		get {
			return	lineNumber - 1
		}
	}
	public var columnIndex:Int {
		get {
			return	columnNumber - 1
		}
	}
}
extension CodeRange: Printable {
	public var description:String {
		get {
			return	"\(startPoint) ~ \(endPoint)"
		}
	}
}