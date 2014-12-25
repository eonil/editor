//
//  SyntaxHighlighting.swift
//  Editor
//
//  Created by Hoon H. on 12/25/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilDispatch

///	Ad-hoc syntax highlighting.
class SyntaxHighlighting {
	let	targetTextView:NSTextView
	
	init(targetTextView:NSTextView) {
		self.targetTextView		=	targetTextView
		reset()
	}
	
	func available() -> Bool {
//		return	multilineCommentIterator!.available()
		return	singlelineCommentIterator!.available() || multilineCommentIterator!.available()
//		return	keywordIterator!.available() || singlelineCommentIterator!.available() || multilineCommentIterator!.available()
	}
	func reset() {
		let	t	=	targetTextView.textStorage!
		let	v	=	t.string.unicodeScalars
		self.keywordIterator			=	MatchingBlockIterator(targetView: v, separators: punctuators())
		self.singlelineCommentIterator	=	EnclosingBlockIterator(targetView: v, startMarkerString: "//", endMarkerString: "\n")
		self.multilineCommentIterator	=	EnclosingBlockIterator(targetView: v, startMarkerString: "/*", endMarkerString: "*/")
	}
	func step() {
		assert(keywordIterator != nil)
		assert(singlelineCommentIterator != nil)
		assert(multilineCommentIterator != nil)
		assertMainThread()
		
		////
		
//		let	ks	=	keywords()
//		if keywordIterator!.available() {
//			let r		=	keywordIterator!.stepInPlace()
//			let	v		=	keywordIterator!.targetString.subviewWithRange(r)
//			let	s		=	String(v)
//			if contains(ks, s) {
//				setColorOnRange(keywordColor(), r)
//			}
//			return
//		}

		if singlelineCommentIterator!.available() {
			let r	=	singlelineCommentIterator!.step()
			setColorOnRange(commentColor(), r)
			return
		}
		
		if multilineCommentIterator!.available() {
			let r	=	multilineCommentIterator!.step()
			setColorOnRange(commentColor(), r)
			return
		}
		
//		Debug.log("syntax highlight stepped: \(distance(keywordIterator!.targetString.startIndex, keywordIterator!.location))")
	}
	
	////
	
	private var keywordIterator:MatchingBlockIterator?
	private var	singlelineCommentIterator:EnclosingBlockIterator?
	private var	multilineCommentIterator:EnclosingBlockIterator?
	
	private func setColorOnRange(c:NSColor, _ r:URange) {
		let	s	=	targetTextView.textStorage!.string
		let	r1	=	s.convertRangeToNSRange(r)
		targetTextView.textStorage!.addAttribute(NSForegroundColorAttributeName, value: c, range: r1)
	}
}

private func commentColor() -> NSColor {
	return	NSColor.withUInt8Components(red: 0, green: 116, blue: 0, alpha: 255)
}
private func keywordColor() -> NSColor {
	return	NSColor.withUInt8Components(red: 170, green: 13, blue: 145, alpha: 255)
}




















typealias	UScalar	=	UnicodeScalar
typealias	UView	=	String.UnicodeScalarView
typealias	UIndex	=	String.UnicodeScalarView.Index
typealias	URange	=	Range<String.UnicodeScalarView.Index>



private struct MatchingBlockIterator {
	let	targetView:UView
	let	separators:[UScalar]
	
	var	location:UIndex
	var	selectionStart:UIndex?
	
	init(targetView:UView, separators:[UScalar]) {
		self.targetView	=	targetView
		self.separators	=	separators
		self.location	=	targetView.startIndex
	}
	
	func available() -> Bool {
		return	location < targetView.endIndex
	}
	
	///	Returns zero-length range at EOF.
	private mutating func stepInPlace() -> URange {
		assert(available())
		
		///	Location will be set to next of last separator character.
		func skipSeparators() {
			while available() && contains(separators, targetView[location]) {
				location++
			}
		}
		///	Location will be set to next of last non-separator character.
		func skipNonSeparators() {
			while available() && contains(separators, targetView[location]) == false {
				location++
			}
		}
		
		skipSeparators()
		if available() {
			let	b	=	location
			skipNonSeparators()
			let	e	=	location
			
			return	URange(start: b, end: e)
		}
		return	URange(start: location, end: location)
	}
}







private struct EnclosingBlockIterator {
	let	targetView:UView
	let	startMarkerString:String
	let	endMarkerString:String
	
	var	location:UIndex
	
	init(targetView:UView, startMarkerString:String, endMarkerString:String) {
		self.targetView			=	targetView
		self.startMarkerString	=	startMarkerString
		self.endMarkerString	=	endMarkerString
		self.location			=	targetView.startIndex
	}
	func available() -> Bool {
		return	location < targetView.endIndex
	}
	
	mutating func step() -> URange {
		assert(available())
		
		///	Current location becomes EOF or begin of starting marker.
		func skipNonStartCharacters() {
			while available() && targetView.subviewFromIndex(location).hasPrefix(startMarkerString) == false {
				location++
			}
		}
		
		///	Current location becomes EOF or begin of ending marker.
		func skipNonEndCharacters() {
			while available() && targetView.subviewFromIndex(location).hasPrefix(endMarkerString) == false {
				location++
			}
		}
		
		///	Current location becomes EOF or next of end of ending marker.
		func skipByEndMarker() {
			if available() {
				assert(targetView.subviewFromIndex(location).hasPrefix(endMarkerString))
				advance(location, countElements(endMarkerString.unicodeScalars))
			}
		}
		
		skipNonStartCharacters()
		let	b	=	location
		skipNonEndCharacters()
		skipByEndMarker()
		let	e	=	location
		
		return	URange(start: b, end: e)
	}
}


private enum Block {
	case None
	case Token(URange)
	
	func range() -> URange? {
		switch self {
			case .Token(let r):	return	r
			default:			return	nil
		}
	}
}


















private func keywords() -> [String] {
	return	[
		"abstract",
		"alignof",
		"as",
		"be",
		"box",
		"break",
		"const",
		"continue",
		"crate",
		"do",
		"else",
		"enum",
		"extern",
		"false",
		"final",
		"fn",
		"for",
		"if",
		"impl",
		"in",
		"let",
		"loop",
		"match",
		"mod",
		"move",
		"mut",
		"offsetof",
		"once",
		"override",
		"priv",
		"pub",
		"pure",
		"ref",
		"return",
		"sizeof",
		"static",
		"self",
		"struct",
		"super",
		"true",
		"trait",
		"type",
		"typeof",
		"unsafe",
		"unsized",
		"use",
		"virtual",
		"where",
		"while",
		"yield",
	]
}

private func punctuators() -> [UScalar] {
	return	["\n", "\t", " ", ".", ",", ":", ";", "{", "}", "(", ")", "\"", "'", "*", "!", "=", "<", ">", "/", "+", "-", "&", "[", "]", "#", "`"]
}

extension unichar: StringLiteralConvertible {
	public init(unicodeScalarLiteral value: String) {
		self.init(stringLiteral: value)
	}
	public init(extendedGraphemeClusterLiteral value: String) {
		self.init(stringLiteral: value)
	}
	public init(stringLiteral value: String) {
		let	s1	=	value as NSString
		assert(s1.length == 1)
		self	=	s1.characterAtIndex(0)
	}
}

extension String.UnicodeScalarView {
	func subviewFromIndex(index:UIndex) -> String.UnicodeScalarView {
		return	self[index..<self.endIndex]
	}
	func subviewToIndex(index:UIndex) -> String.UnicodeScalarView {
		return	self[self.startIndex..<index]
	}
	func subviewWithRange(range:URange) -> String.UnicodeScalarView {
		return	self[range]
	}
	
	func hasPrefix(s:String) -> Bool {
		return	String(self).hasPrefix(s)
	}
}






