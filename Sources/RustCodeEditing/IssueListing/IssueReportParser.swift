//
//  IssueReportParser.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/10/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

struct IssueReportParser {
	func parse(reportOutput:String, filePath:String) -> [Issue] {
		func makeIssue(ln1:String) -> Issue? {
			if let ln2 = parseIssueLine(ln1, filePath) {
				let	s1	=	Issue(path: filePath, range:ln2.range, type:ln2.type, text: ln2.description)
				return	s1
			}
			return	nil
		}
		let	lns1	=	split(reportOutput, {$0 == "\n"}, maxSplit: Int.max, allowEmptySlices: false)
		let	ss2		=	lns1.map(makeIssue).filter({$0 != nil }).map {$0!}
		return	ss2
	}
}

private func parseIssueLine(line:String, fileName:String) -> (range:Issue.Range, type:Issue.Class, description:String)? {
	if line.hasPrefix(fileName) {
		let	rest1	=	line.substringFromIndex(fileName.endIndex)
		let	scan1	=	NSScanner(string: rest1)
		if scan1.scanString(":", intoString: nil) {
			if let ln1 = scan1.scanInt() {
				if scan1.scanString(":", intoString: nil) {
					if let col1 = scan1.scanInt() {
						if scan1.scanString(": ", intoString: nil) {
							if let ln2 = scan1.scanInt() {
								if scan1.scanString(":", intoString: nil) {
									if let col2 = scan1.scanInt() {
										
										if let cls1 = scan1.scanUpToString(":") {
											let	loc1	=	Issue.Location(line: ln1-1, column: col1-1)
											let	loc2	=	Issue.Location(line: ln2-1, column: col2-1)
											let	ran1	=	Issue.Range(start: loc1, end: loc2)
											let	cls2	=	Issue.Class(rawValue: cls1)!
											
											scan1.scanString(": ", intoString: nil)
											let	rest1	=	scan1.scanUpToString("\n")!
											return	(range:ran1, type:cls2, description:rest1)
										}
										
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return	nil
}









//
//private func parse(report:String, filePath:String) -> [Issue] {
//	var	issues1	=	[] as [Issue]
//	getBlocks(report, filePath) { (blockLines:[String]) -> () in
//		assert(blockLines.count > 0)
//		assert(blockLines[0].endIndex >= filePath.endIndex)
//		let	issue1	=	makeIssueFromBlock(blockLines, filePath)
//		issues1.append(issue1)
//	}
//	return	issues1
//}
//
//
//private func getBlocks(report:String, filePath:String, onBlock:([String])->()) {
//	var	block1	=	[] as [String]
//	let	lines1	=	split(report, {$0 == "\n"}, maxSplit: Int.max, allowEmptySlices: false)
//	for line in lines1 {
//		if line.hasPrefix(filePath) {
//			if block1.count > 0 {
//				onBlock(block1)
//			}
//			block1	=	[line]
//		} else {
//			block1.append(line)
//		}
//	}
//	if block1.count > 0 {
//		onBlock(block1)
//	}
//}
//private func makeIssueFromBlock(blockLines:[String], filePath:String) -> Issue {
//	assert(blockLines.count > 0)
//	let	firstln		=	blockLines[0]
//	let	nonNamePart	=	firstln[filePath.endIndex..<firstln.endIndex]
//	
//	var	block2		=	blockLines
//	block2[0]		=	nonNamePart
//	let	s			=	join("\n", block2)
//	let	linenum		=	-1
//	let	colnum		=	-1
//	return	Issue(filePath: filePath, lineNumber: linenum, columnNumber: colnum, description: s)
//}
//















