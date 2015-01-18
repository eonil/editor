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
			return	"(\(range) [\(severity.rawValue)] \(location): \(message.debugDescription))"
		}
	}
}
