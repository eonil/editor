////
////  SyntaxHighlighting.swift
////  Editor
////
////  Created by Hoon H. on 12/25/14.
////  Copyright (c) 2014 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//import EonilDispatch
//
/////	Ad-hoc syntax highlighting.
//class SyntaxHighlighting {
//	let	targetTextView:CodeTextView
//	
//	init(targetTextView:CodeTextView) {
//		self.targetTextView		=	targetTextView
//		reset()
//	}
//	
//	func available() -> Bool {
//		return	cursor!.available()
//	}
//	func reset() {
//		let	c	=	Cursor(targetView: targetTextView.textStorage!.string.unicodeScalars)
//		self.cursor						=	c
//		self.singlelineCommentScanner	=	EnclosingBlockScanner(cursor: c, startMarkerString: "//", endMarkerString: "\n")
//		self.multilineCommentScanner	=	EnclosingBlockScanner(cursor: c, startMarkerString: "/*", endMarkerString: "*/")
//		self.attributeScanner1			=	EnclosingBlockScanner(cursor: c, startMarkerString: "#[", endMarkerString: "]")
//		self.attributeScanner2			=	EnclosingBlockScanner(cursor: c, startMarkerString: "#![", endMarkerString: "]")
//		self.stringScanner				=	EnclosingBlockScanner(cursor: c, startMarkerString: "\"", endMarkerString: "\"")
//		self.tokenScanner				=	TokenScanner(cursor: c, separators: punctuators())
//	}
//	func step() {
//		assert(tokenScanner != nil)
//		assert(singlelineCommentScanner != nil)
//		assert(multilineCommentScanner != nil)
//		assertMainThread()
//		
//		////
//
//		if singlelineCommentScanner!.available() {
//			let r	=	singlelineCommentScanner!.scan()
//			setBlockTypeOnRange(CodeTextStorage.SyntacticType.Comment, r)
////			setColorOnRange(commentColor(), r)
//			return
//		}
//		
//		if multilineCommentScanner!.available() {
//			let r	=	multilineCommentScanner!.scan()
//			setBlockTypeOnRange(CodeTextStorage.SyntacticType.Comment, r)
////			setColorOnRange(commentColor(), r)
//			return
//		}
//		
//		if attributeScanner1!.available() {
//			let	r	=	attributeScanner1!.scan()
//			setBlockTypeOnRange(CodeTextStorage.SyntacticType.Attribute, r)
////			setColorOnRange(attributeColor(), attributeScanner1!.scan())
//			return
//		}
//		if attributeScanner2!.available() {
//			let	r	=	attributeScanner2!.scan()
//			setBlockTypeOnRange(CodeTextStorage.SyntacticType.Attribute, r)
////			setColorOnRange(attributeColor(), attributeScanner2!.scan())
//			return
//		}
//		
//		if stringScanner!.available() {
//			let	r	=	stringScanner!.scan()
//			setBlockTypeOnRange(CodeTextStorage.SyntacticType.String, r)
////			setColorOnRange(stringColor(), stringScanner!.scan())
//			return
//		}
//		
//		if tokenScanner!.available() {
//			let	ks	=	keywords()
//			let	r	=	tokenScanner!.scan()
//			let	s	=	String(cursor!.targetView[r])
//			if contains(ks, s) {
//				setBlockTypeOnRange(CodeTextStorage.SyntacticType.Keyword, r)
////				setColorOnRange(keywordColor(), r)
//			} else {
//				setBlockTypeOnRange(CodeTextStorage.SyntacticType.None, r)
////				unsetColorOnRange(r)
//			}
//			return
//		}
//		
//		let	r	=	cursor!.location..<cursor!.location.successor()
//		setBlockTypeOnRange(CodeTextStorage.SyntacticType.None, r)
////		unsetColorOnRange(cursor!.location..<cursor!.location.successor())
//		cursor!.step()
//	}
//	
//	////
//	
//	private var	cursor:Cursor?
//	private var	singlelineCommentScanner:EnclosingBlockScanner?
//	private var	multilineCommentScanner:EnclosingBlockScanner?
//	private var	attributeScanner1:EnclosingBlockScanner?
//	private var	attributeScanner2:EnclosingBlockScanner?
//	private var	stringScanner:EnclosingBlockScanner?
//	private var tokenScanner:TokenScanner?
//
//	private func setBlockTypeOnRange(blockType:CodeTextStorage.SyntacticType, _ r:URange) {
//		let	s	=	targetTextView.textStorage!.string
//		let	r1	=	s.convertRangeToNSRange(r)
//		targetTextView.codeTextStorage.setSyntacticType(blockType, range: r1, notify:false)
//	}
//
////	private func setColorOnRange(c:NSColor, _ r:URange) {
////		let	s	=	targetTextView.textStorage!.string
////		let	r1	=	s.convertRangeToNSRange(r)
////		targetTextView.codeTextStorage.setSyntacticType(CodeTextStorage.SyntacticType.Comment, range: r1, notify:false)
//////		targetTextView.textStorage!.addAttribute(NSForegroundColorAttributeName, value: c, range: r1)
////	}
////	private func unsetColorOnRange(r:URange) {
////		let	s	=	targetTextView.textStorage!
////		let	r1	=	s.string.convertRangeToNSRange(r)
////		targetTextView.codeTextStorage.setSyntacticType(CodeTextStorage.SyntacticType.None, range: r1, notify:false)
////		
//////		//	Removing attribute takes too long time. Triggers layout. I don't know how to prevent it.
//////		//	Check before removing it.
//////		
//////		s.enumerateAttributesInRange(r1, options: NSAttributedStringEnumerationOptions.allZeros) { (map:[NSObject : AnyObject]!, r:NSRange, p:UnsafeMutablePointer<ObjCBool>) -> Void in
//////			if contains(map.keys, NSForegroundColorAttributeName) {
//////				s.removeAttribute(NSForegroundColorAttributeName, range: r1)
//////				p.memory	=	false
//////			}
//////		}
////	}
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//private struct TokenScanner {
//	let	separators:[UScalar]
//	var	selectionStart:UIndex?
//	
//	unowned var	cursor:Cursor
//	
//	init(cursor:Cursor, separators:[UScalar]) {
//		self.cursor			=	cursor
//		self.separators		=	separators
//	}
//	
//	func available() -> Bool {
//		return	cursor.available() && contains(separators, cursor.currentScalar()) == false
//	}
//	
//	///	Returns zero-length range at EOF.
//	mutating func scan() -> URange {
//		assert(available())
//		
//		let	b	=	cursor.location
//		while available() {
//			cursor.step()
//		}
//		let	e	=	cursor.location
//		return	URange(start: b, end: e)
//	}
//}
//
//
//
//
//
//
//
//private struct EnclosingBlockScanner {
//	let	startMarkerString:String
//	let	endMarkerString:String
//	
//	unowned let	cursor:Cursor
//	
//	init(cursor:Cursor, startMarkerString:String, endMarkerString:String) {
//		self.cursor				=	cursor
//		self.startMarkerString	=	startMarkerString
//		self.endMarkerString	=	endMarkerString
//	}
//	
//	func available() -> Bool {
//		return	cursor.available() && cursor.restString().hasPrefix(startMarkerString)
//	}
//	
//	mutating func scan() -> URange {
//		assert(available())
//		
//		func skipBy(s:String) {
//			cursor.location	=	advance(cursor.location, countElements(s.unicodeScalars))
//		}
//		
//		let	b	=	cursor.location
//		skipBy(startMarkerString)
//		while cursor.available() && cursor.restString().hasPrefix(endMarkerString) == false {
//			cursor.step()
//		}
//		skipBy(endMarkerString)
//		let	e	=	cursor.location
//		
//		return	URange(start: b, end: e)
//	}
//}
//
//
//
//
//
//
//
//
//
//
//private class Cursor {
//	let	targetView:UView
//	var	location:UIndex
//	
//	init(targetView:UView) {
//		self.targetView	=	targetView
//		self.location	=	targetView.startIndex
//	}
//	func available() -> Bool {
//		return	location < targetView.endIndex
//	}
//	func currentScalar() -> UScalar {
//		precondition(available())
//		return	targetView[location]
//	}
//	func restView() -> UView {
//		return	targetView[location..<targetView.endIndex]
//	}
//	func restString() -> String {
//		return	String(restView())
//	}
//	
//	func step() {
//		precondition(location < targetView.endIndex)
//		location++
//	}
//	
////	func pastView() -> UView {
////		return	targetView[targetView.startIndex..<location]
////	}
////	func restView() -> UView {
////		return	targetView[location..<targetView.endIndex]
////	}
////
////	mutating func stepBackward() {
////		precondition(location > targetView.startIndex)
////		location--
////	}
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
/////	MARK:	Utilities
//
//
////extension unichar: StringLiteralConvertible {
////	public init(unicodeScalarLiteral value: String) {
////		self.init(stringLiteral: value)
////	}
////	public init(extendedGraphemeClusterLiteral value: String) {
////		self.init(stringLiteral: value)
////	}
////	public init(stringLiteral value: String) {
////		let	s1	=	value as NSString
////		assert(s1.length == 1)
////		self	=	s1.characterAtIndex(0)
////	}
////}
//
//extension String.UnicodeScalarView {
//	func subviewFromIndex(index:UIndex) -> String.UnicodeScalarView {
//		return	self[index..<self.endIndex]
//	}
//	func subviewToIndex(index:UIndex) -> String.UnicodeScalarView {
//		return	self[self.startIndex..<index]
//	}
//	func subviewWithRange(range:URange) -> String.UnicodeScalarView {
//		return	self[range]
//	}
//	
//	func hasPrefix(s:String) -> Bool {
//		return	String(self).hasPrefix(s)
//	}
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
/////	MARK:	Data Section
//
////private func stringColor() -> NSColor {
////	return	NSColor.withUInt8Components(red: 196, green: 26, blue: 22, alpha: 255)
////}
////private func attributeColor() -> NSColor {
////	return	NSColor.withUInt8Components(red: 131, green: 108, blue: 40, alpha: 255)
////}
////private func commentColor() -> NSColor {
////	return	NSColor.withUInt8Components(red: 0, green: 116, blue: 0, alpha: 255)
////}
////private func keywordColor() -> NSColor {
////	return	NSColor.withUInt8Components(red: 170, green: 13, blue: 145, alpha: 255)
////}
//
//private func keywords() -> [String] {
//	return	[
//		"abstract",
//		"alignof",
//		"as",
//		"be",
//		"box",
//		"break",
//		"const",
//		"continue",
//		"crate",
//		"do",
//		"else",
//		"enum",
//		"extern",
//		"false",
//		"final",
//		"fn",
//		"for",
//		"if",
//		"impl",
//		"in",
//		"let",
//		"loop",
//		"match",
//		"mod",
//		"move",
//		"mut",
//		"offsetof",
//		"once",
//		"override",
//		"priv",
//		"pub",
//		"pure",
//		"ref",
//		"return",
//		"sizeof",
//		"static",
//		"self",
//		"struct",
//		"super",
//		"true",
//		"trait",
//		"type",
//		"typeof",
//		"unsafe",
//		"unsized",
//		"use",
//		"virtual",
//		"where",
//		"while",
//		"yield",
//	]
//}
//
//private func punctuators() -> [UScalar] {
//	return	["\n", "\t", " ", ".", ",", ":", ";", "{", "}", "(", ")", "\"", "'", "*", "!", "=", "<", ">", "/", "+", "-", "&", "[", "]", "#", "`"]
//}
//
//
//
//
//
//
