//
//  RustCompilerIssue.swift
//  Precompilation
//
//  Created by Hoon H. on 2015/01/17.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

public struct RustCompilerIssue {
	public var	location:String
	public var	range:CodeRange
	public var	severity:Severity
	public var	message:String
	
	public struct CodePoint {
		public var	lineNumber:Int		///	1-based.
		public var	columnNumber:Int	///	1-based.
	}
	
	public struct CodeRange {
		public var	startPoint:CodePoint
		public var	endPoint:CodePoint
	}
	
	public enum Severity: String {
		case Error		=	"error"
		case Warning	=	"warning"
		case Note		=	"note"
		case Help		=	"help"
	}
}

extension RustCompilerIssue: Printable {
	public var description:String {
		get {
			return	"(\(range): \(severity.rawValue): \(location): \(message))"
		}
	}
}

extension RustCompilerIssue.CodePoint: Printable {
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
extension RustCompilerIssue.CodeRange: Printable {
	public var description:String {
		get {
			return	"\(startPoint) ~ \(endPoint)"
		}
	}
}