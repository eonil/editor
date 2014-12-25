//
//  Issue.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

struct Issue {
	let	path:String
	let	range:Range
	let	type:Class
	let	text:String
	
	struct Location {
		var	line:Int			///	0-based index.
		var	column:Int			///	0-based index.
	}
	struct Range {
		var	start:Location
		var	end:Location
	}
	
	enum Class : String {
		case Warning	=	"warning"
		case Error		=	"error"
		case Note		=	"note"
		case Help		=	"help"
	}
}

extension Issue.Location : Printable {
	var description:String {
		get {
			return	"\(line):\(column)"
		}
	}
}

extension Issue.Range : Printable {
	var description:String {
		get {
			return	"\(start) ~ \(end)"
		}
	}
}




