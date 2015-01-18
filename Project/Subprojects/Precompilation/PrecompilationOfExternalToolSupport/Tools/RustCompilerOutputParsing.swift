//
//  RustCompilerOutputParsing.swift
//  Precompilation
//
//  Created by Hoon H. on 2015/01/17.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation






public struct RustCompilerOutputParsing {
	public static func parseErrorOutput(s:String) -> [RustCompilerIssue] {
		return	run1(s)
	}
	
	private static func run1(s:String) -> [RustCompilerIssue] {
		let	lns	=	split(s, { (ch:Character)->Bool in return ch == "\n" }, maxSplit: Int.max, allowEmptySlices: true).map { (ln:String)->String in
			return	ln + "\n"
		}
		
		var	isss	=	[] as [RustCompilerIssue]
		
		LINELOOP:
		for ln in lns {
			var	p	=	IssueParser()
			for ch in ln {
				if p.accepts(ch) {
					p.push(ch)
				} else {
					continue LINELOOP
				}
			}
			
			if p.sufficient() {
				//	Just skip invalid lines.
				isss.append(p.produce())
			}
		}
		return	isss
	}
}


























//struct RustCompilerOutputParsing {
//	static func parseErrorOutput(s:String) -> [RustCompilerIssue] {
//		return	run1(s)
//	}
//	
//	private static func run1(s:String) -> [RustCompilerIssue] {
//		let	lns	=	split(s, { (ch:Character)->Bool in return ch == "\n" }, maxSplit: Int.max, allowEmptySlices: true)
//		println(lns)
//		
//		var	isss	=	[] as [RustCompilerIssue]
//		for ln in lns {
//			var	p	=	Parser()
//			for ch in ln {
//				p.push(ch)
//			}
//			if p.phase == Parser.Phase.MSG {
//				isss.append(p.makeRustCompilerIssue())
//			}
//		}
//		return	isss
//	}
//}
//
//
//
//private struct Parser {
//	var	phase:Phase	=	.LOC
//	var	loc:String	=	""
//	var	ln1:String	=	""
//	var	col1:String	=	""
//	var	ln2:String	=	""
//	var	col2:String	=	""
//	var	sev:String	=	""
//	var	msg:String	=	""
//	
//	func makeRustCompilerIssue() -> RustCompilerIssue {
//		let	loc	=	self.loc
//		let	l1	=	ln1.toInt()!
//		let	c1	=	col1.toInt()!
//		let	l2	=	ln2.toInt()!
//		let	c2	=	col2.toInt()!
//		
//		let	p1	=	RustCompilerIssue.CodePoint(lineNumber: l1, columnNumber: c1)
//		let	p2	=	RustCompilerIssue.CodePoint(lineNumber: l2, columnNumber: c2)
//		let	ran	=	RustCompilerIssue.CodeRange(startPoint: p1, endPoint: p2)
//		
//		let	se	=	RustCompilerIssue.Severity(rawValue: sev)!
//		let	msg	=	self.msg.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//		
//		let	iss	=	RustCompilerIssue(location: loc, range: ran, severity: se, message: msg)
//		return	iss
//	}
//	
//	func preview(ch:Character) {
//		
//	}
//	mutating func push(ch:Character) {
//		switch phase {
//		case .LOC:
//			if ch == ":" {
//				phase	=	.LN1
//			} else {
//				loc.append(ch)
//			}
//			
//		case .LN1:
//			if ch == ":" {
//				phase	=	.COL1
//			} else {
//				ln1.append(ch)
//			}
//			
//		case .COL1:
//			if ch == ":" {
//				phase	=	.LN2
//			} else {
//				col1.append(ch)
//			}
//			
//		case .LN2:
//			if ch == " " {
//				return
//			}
//			if ch == ":" {
//				phase	=	.COL2
//			} else {
//				ln2.append(ch)
//			}
//			
//		case .COL2:
//			if ch == " " {
//				phase	=	.SEV
//			} else {
//				col2.append(ch)
//			}
//			
//		case .SEV:
//			if ch == ":" {
//				phase	=	.MSG
//			} else {
//				sev.append(ch)
//			}
//			
//		case .MSG:
//			msg.append(ch)
//		}
//	}
//	
//	
//	
//	enum Phase {
//		case LOC
//		case LN1
//		case COL1
//		case LN2
//		case COL2
//		case SEV
//		case MSG
//	}
//}

























private struct IssueParser: ParserType {
	var	filename	=	AnyCharacterStringWithEndMarkerParser(exclusiveEndMarker: ":")
	var	range		=	RangeParser()
	var	severity	=	AnyCharacterStringWithEndMarkerParser(exclusiveEndMarker: ":")
	var	message		=	AnyCharacterStringWithEndMarkerParser(exclusiveEndMarker: "\n")
	
	var	p			=	phase.FILENAME
	
	enum phase {
		case FILENAME
		case RANGE
		case SEVERITY
		case MESSAGE
	}

	func sufficient() -> Bool {
		return	filename.sufficient() && range.sufficient() && severity.sufficient() && message.sufficient()
	}
	
	func accepts(ch:Character) -> Bool {
		switch p {
		case .FILENAME:
			return	filename.accepts(ch)
			
		case .RANGE:
			return	range.accepts(ch) || ch == " "
			
		case .SEVERITY:
			return	severity.accepts(ch)
			
		case .MESSAGE:
			return	message.accepts(ch)	
		}
	}
	func produce() -> RustCompilerIssue {
		assert(filename.sufficient())
		assert(range.sufficient())
		assert(severity.sufficient())
		assert(message.sufficient())
		assert(sufficient())
		let	loc	=	filename.produce()
		let	ran	=	range.produce()
		let	se	=	RustCompilerIssue.Severity(rawValue: severity.produce())!
		let	msg	=	message.produce().stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		let	iss	=	RustCompilerIssue(location: loc, range: ran, severity: se, message: msg)
		return	iss
	}
	
	mutating func push(ch:Character) {
		assert(accepts(ch))
		
		switch p {
		case .FILENAME:
			filename.push(ch)
			if filename.sufficient() {
				p	=	phase.RANGE
			}
			
		case .RANGE:
			if range.accepts(ch) {
				range.push(ch)
			} else {
				precondition(ch == " ")
				p	=	phase.SEVERITY
			}
			
		case .SEVERITY:
			severity.push(ch)
			if severity.sufficient() {
				p	=	phase.MESSAGE
			}
			
		case .MESSAGE:
			message.push(ch)
		}
	}
}























///	Accepts including end-marker, and product content excluding the end-marker.
private struct AnyCharacterStringWithEndMarkerParser {
	let	exclusiveEndMarker	:	Character
	var	buffer				=	""
	var	hasFinished			=	false
	init(exclusiveEndMarker:Character) {
		self.exclusiveEndMarker	=	exclusiveEndMarker
	}
	
	func sufficient() -> Bool {
		return	hasFinished
	}
	func accepts(ch:Character) -> Bool {
		return	hasFinished == false
	}
	func produce() -> String {
		assert(sufficient())
		return	buffer
	}
	mutating func push(ch:Character) {
		assert(accepts(ch))
		if ch == exclusiveEndMarker {
			hasFinished	=	true
		} else {
			buffer.append(ch)
		}
	}
}


///
private struct RangeParser: ParserType {
	var	start	=	PointParser()
	var	end		=	PointParser()
	var	p		=	phase.START
	
	enum phase {
		case START
		case END
	}
	
	func sufficient() -> Bool {
		return	start.sufficient() && end.sufficient()
	}
	func accepts(ch:Character) -> Bool {
		switch p {
		case .START:
			return		ch == " " || ch == ":" || start.accepts(ch)
			
		case .END:
			return		end.accepts(ch) || (end.sufficient() == false && ch == " ")
		}
	}
	func produce() -> CodeRange {
		assert(sufficient())
		return	CodeRange(startPoint: start.produce(), endPoint: end.produce())
	}
	mutating func push(ch:Character) {
		assert(accepts(ch))
		
		if ch == " " {
			return
		}
		
		switch p {
		case .START:
			if start.accepts(ch) {
				start.push(ch)
			} else {
				precondition(ch == ":")
				p	=	phase.END
			}
			
		case .END:
			end.push(ch)
		}
	}
}

private struct PointParser: ParserType {
	var	line	=	NumberParser()
	var	col		=	NumberParser()
	var p		=	phase.LINE
	
	enum phase {
		case LINE
		case COL
	}
	
	func sufficient() -> Bool {
		return	line.sufficient() && col.sufficient()
	}
	func accepts(ch:Character) -> Bool {
		switch p {
		case .LINE:
			return	ch == ":" || line.accepts(ch)
			
		case .COL:
			return	col.accepts(ch)
		}
	}
	func produce() -> CodePoint {
		assert(sufficient())
		return	CodePoint(lineNumber: line.produce(), columnNumber: col.produce())
	}
	mutating func push(ch:Character) {
		assert(accepts(ch))
		
		switch p {
		case .LINE:
			if ch == ":" {
				p	=	phase.COL
			} else {
				line.push(ch)
			}
			
		case .COL:
			col.push(ch)
		}
	}
}
private struct NumberParser: ParserType {
	var	buffer	=	""
	func sufficient() -> Bool {
		return	buffer.startIndex < buffer.endIndex
	}
	func accepts(ch:Character) -> Bool {
		switch ch {
		case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
			return	true
		default:
			return	false
		}
	}
	func produce() -> Int {
		assert(sufficient())
		return	buffer.toInt()!
	}
	mutating func reset() {
		buffer	=	""
	}
	mutating func push(ch:Character) {
		assert(accepts(ch))
		buffer.append(ch)
	}
}



private protocol ParserType {
	typealias	Product
	
	///	Pushed data is SUFFICIENT to build a minimal production.
	func sufficient() -> Bool
	///	This can ACCEPT more data to build maximum production. If this returns `false`, that means this parser reached to maximum state.
	func accepts(ch:Character) -> Bool
	func produce() -> Product
	mutating func push(ch:Character)
}
















































///	MARK:

extension UnitTest {
	static func testRustCompilerIssueParsing() {
		test1()
	}
}

private func run(f:()->()) {
	f()
}
private func test1() {
	run {
		let	s	=	"123"
		var	p	=	NumberParser()
		
		for ch in s {
			p.push(ch)
		}
		
		assert(p.produce() == 123)
	}
	run {
		let	s	=	"123:567"
		var	p	=	PointParser()
		
		for ch in s {
			p.push(ch)
		}
		
		assert(p.produce().lineNumber == 123)
		assert(p.produce().columnNumber == 567)
	}
	run {
		let	s	=	"111:222: 333:444"
		var	p	=	RangeParser()
		
		for ch in s {
			p.push(ch)
		}
		
		assert(p.produce().startPoint.lineNumber == 111)
		assert(p.produce().startPoint.columnNumber == 222)
		assert(p.produce().endPoint.lineNumber == 333)
		assert(p.produce().endPoint.columnNumber == 444)
	}
	run {
		let	s	=	"/somefile.rs:111:222: 333:445 error: mmm,,,\n"
		var	p	=	IssueParser()
		
		for ch in s {
			if ch == "5" {
				println()
			}
			p.push(ch)
		}
		
		assert(p.produce().location == "/somefile.rs")
		assert(p.produce().range.startPoint.lineNumber == 111)
		assert(p.produce().range.startPoint.columnNumber == 222)
		assert(p.produce().range.endPoint.lineNumber == 333)
		assert(p.produce().range.endPoint.columnNumber == 445)
		assert(p.produce().severity == RustCompilerIssue.Severity.Error)
		assert(p.produce().message == "mmm,,,")
	}
}


















