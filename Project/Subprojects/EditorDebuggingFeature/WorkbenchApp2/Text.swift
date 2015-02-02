//
//  Text.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/02/03.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit



///	A utility to make `NSAttributedString` easily.
struct Text {
	private var	s	=	NSAttributedString()
	
	init() {
	}
	init(_ s:String) {
		self.s	=	NSMutableAttributedString(string: s)
	}
	init(_ s:NSAttributedString) {
		self.s	=	s
	}
	
	var	attributedString:NSAttributedString {
		get {
			return	s
		}
	}
	
	func setFont(font:NSFont) -> Text {
		return	textByResettingAttribute(NSFontAttributeName, value: font)
	}
	
	func setTextColor(color:NSColor) -> Text {
		return	textByResettingAttribute(NSForegroundColorAttributeName, value: color)
	}
	func setKern(kern:CGFloat) -> Text {
		return	textByResettingAttribute(NSKernAttributeName, value: NSNumber(double: Double(kern)))
	}
	
	private func textByResettingAttribute(attribute:NSString, value:AnyObject) -> Text {
		let	a1	=	[attribute: value]
		let	s2	=	NSMutableAttributedString(attributedString: s)
		let	r1	=	NSRange(location: 0, length: (s2.string as NSString).length)
		s2.addAttribute(attribute, value: value, range: r1)
		
		return	Text(s2)
	}
}

func + (left:Text, right:Text) -> Text {
	let	s1	=	NSMutableAttributedString()
	s1.appendAttributedString(left.attributedString)
	s1.appendAttributedString(right.attributedString)
	return	Text(s1)
}




