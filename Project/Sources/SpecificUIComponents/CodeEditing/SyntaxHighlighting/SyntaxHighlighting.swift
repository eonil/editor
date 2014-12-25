//
//  SyntaxHighlighting.swift
//  Editor
//
//  Created by Hoon H. on 12/25/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit

///	Ad-hoc syntax highlighting.
struct SyntaxHighlighting {
	let	targetTextView:NSTextView
	
	init(targetTextView:NSTextView) {
		self.targetTextView	=	targetTextView
	}
	
	func applyAll() {
		let	ks	=	keywords()
		var	ss	=	SubstringIterator(targetString: targetTextView.textStorage!.string)
		while ss.available() {
			let r	=	ss.step()
			let	s	=	ss.targetString.substringWithRange(r)
			if contains(ks, s) {
				setColorOnRange(keywordColor(), r)
			}
		}
		
		var	b1	=	BlockIterator(targetString: targetTextView.textStorage!.string, startMarkerString: "//", endMarkerString: "\n", location: 0)
		while b1.available() {
			let r	=	b1.step()
			setColorOnRange(commentColor(), r)
		}
		
		var	b2	=	BlockIterator(targetString: targetTextView.textStorage!.string, startMarkerString: "/*", endMarkerString: "*/", location: 0)
		while b2.available() {
			let r	=	b2.step()
			setColorOnRange(commentColor(), r)
		}
	}
	private func setColorOnRange(c:NSColor, _ r:NSRange) {
		targetTextView.textStorage!.addAttribute(NSForegroundColorAttributeName, value: c, range: r)
	}
}

private func commentColor() -> NSColor {
	return	NSColor.withUInt8Components(red: 0, green: 116, blue: 0, alpha: 255)
}
private func keywordColor() -> NSColor {
	return	NSColor.withUInt8Components(red: 170, green: 13, blue: 145, alpha: 255)
}































private struct SubstringIterator {
	let	targetString:NSString
	let	separators:[unichar]		=	punctuators()
	
	var	location:NSInteger			=	0
	var	selectionStart:NSInteger?	=	nil
	
	init(targetString:NSString) {
		self.targetString	=	targetString
	}
	
	func available() -> Bool {
		return	location < targetString.length
	}
	mutating func step() -> NSRange {
		assert(available())
		
		///	Location will be set to next of last separator character.
		func skipSeparators() {
			while available() && contains(separators, targetString.characterAtIndex(location)) {
				location++
			}
		}
		///	Location will be set to next of last non-separator character.
		func skipNonSeparators() {
			while available() && contains(separators, targetString.characterAtIndex(location)) == false {
				location++
			}
		}
		
		skipSeparators()
		if available() {
			let	s	=	location
			skipNonSeparators()
			let	end	=	location
			return	NSRange(location: s, length: end - s)
		}
		return	NSRange(location: location, length: 0)
	}
}







private struct BlockIterator {
	let	targetString:NSString
	let	startMarkerString:NSString
	let	endMarkerString:NSString
	
	var	location:NSInteger	=	0
	
	func available() -> Bool {
		return	location < targetString.length
	}
	
	mutating func step() -> NSRange {
		assert(available())
		
		///	Current location becomes EOF or begin of starting marker.
		func skipNonStartCharacters() {
			while available() && targetString.substringFromIndex(location).hasPrefix(startMarkerString) == false {
				location++
			}
		}
		
		///	Current location becomes EOF or begin of ending marker.
		func skipNonEndCharacters() {
			while available() && targetString.substringFromIndex(location).hasPrefix(endMarkerString) == false {
				location++
			}
		}
		
		///	Current location becomes EOF or next of end of ending marker.
		func skipByEndMarker() {
			if available() {
				assert(targetString.substringFromIndex(location).hasPrefix(endMarkerString))
				location	+=	endMarkerString.length
			}
		}
		
		skipNonStartCharacters()
		let	loc		=	location
		skipNonEndCharacters()
		skipByEndMarker()
		let	end		=	location
		
		return	NSRange(location: loc, length: end - loc)
	}
}


//
//private struct BlockDetector {
//	let	targetString:NSString
//	let	startMarkerString:NSString
//	let	endMarkerString:NSString
//	
//	var	location:NSInteger	=	0
//	
//	func available() -> Bool {
//		return	location < targetString.length
//	}
//	
//	///	Returns a range if `targetString` has a comment at current location.
//	///	Returns `nil` otherwise.
//	///	EOF also treated as an end-marker.
//	mutating func test() -> NSRange? {
//		if targetString.substringFromIndex(location).hasPrefix(startMarkerString) {
//			let	loc	=	location
//			while available() && targetString.substringFromIndex(location).hasPrefix(endMarkerString) == false {
//				location++
//			}
//			let	len	=	location - loc
//			return	NSRange(location: loc, length: len)
//		}
//		return	nil
//	}
//	
//	static func test(string:NSString, location:NSInteger) -> NSRange? {
//		var	d1	=	BlockDetector(targetString: string, startMarkerString: "//", endMarkerString: "\n", location: location)
//		var	d2	=	BlockDetector(targetString: string, startMarkerString: "/*", endMarkerString: "*/", location: location)
//		
//		if let r = d1.test() {
//			return	r
//		}
//		if let r = d2.test() {
//			return	r
//		}
//		return	nil
//	}
//}



















private func keywords() -> [NSString] {
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

private func punctuators() -> [unichar] {
	return	["\n", "\t", " ", ".", ",", ":", ";", "{", "}", "(", ")", "\"", "'", "*", "!", "=", "<", ">", "/", "+", "-", "&", "[", "]", "#", "`"] as [unichar]
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








