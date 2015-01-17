//
//  RustCompilerOutputParsing.swift
//  Precompilation
//
//  Created by Hoon H. on 2015/01/17.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

struct RustCompilerOutputParsing {
	static func parseErrorOutput(s:String) -> [RustCompilerIssue] {
		return	run1(s)
	}
	
	private static func run1(s:String) -> [RustCompilerIssue] {
		let	lns	=	split(s, { (ch:Character)->Bool in return ch == "\n" }, maxSplit: Int.max, allowEmptySlices: true)
		println(lns)
		
		var	isss	=	[] as [RustCompilerIssue]
		for ln in lns {
			var	p	=	Parser()
			for ch in ln {
				p.push(ch)
			}
			if p.phase == Parser.Phase.MSG {
				isss.append(p.makeRustCompilerIssue())
			}
		}
		return	isss
	}
}







private struct Parser {
	var	phase:Phase	=	.LOC
	var	loc:String	=	""
	var	ln1:String	=	""
	var	col1:String	=	""
	var	ln2:String	=	""
	var	col2:String	=	""
	var	sev:String	=	""
	var	msg:String	=	""
	
	func makeRustCompilerIssue() -> RustCompilerIssue {
		let	loc	=	self.loc
		let	l1	=	ln1.toInt()!
		let	c1	=	col1.toInt()!
		let	l2	=	ln2.toInt()!
		let	c2	=	col2.toInt()!
		
		let	p1	=	RustCompilerIssue.CodePoint(lineNumber: l1, columnNumber: c1)
		let	p2	=	RustCompilerIssue.CodePoint(lineNumber: l2, columnNumber: c2)
		let	ran	=	RustCompilerIssue.CodeRange(startPoint: p1, endPoint: p2)
		
		let	se	=	RustCompilerIssue.Severity(rawValue: sev)!
		let	msg	=	self.msg.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		
		let	iss	=	RustCompilerIssue(location: loc, range: ran, severity: se, message: msg)
		return	iss
	}
	
	mutating func push(ch:Character) {
		switch phase {
		case .LOC:
			if ch == ":" {
				phase	=	.LN1
			} else {
				loc.append(ch)
			}
			
		case .LN1:
			if ch == ":" {
				phase	=	.COL1
			} else {
				ln1.append(ch)
			}
			
		case .COL1:
			if ch == ":" {
				phase	=	.LN2
			} else {
				col1.append(ch)
			}
			
		case .LN2:
			if ch == " " {
				return
			}
			if ch == ":" {
				phase	=	.COL2
			} else {
				ln2.append(ch)
			}
			
		case .COL2:
			if ch == " " {
				phase	=	.SEV
			} else {
				col2.append(ch)
			}
			
		case .SEV:
			if ch == ":" {
				phase	=	.MSG
			} else {
				sev.append(ch)
			}
			
		case .MSG:
			msg.append(ch)
		}
	}
	
	
	
	enum Phase {
		case LOC
		case LN1
		case COL1
		case LN2
		case COL2
		case SEV
		case MSG
	}
}




