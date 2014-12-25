//
//  VersioningText.swift
//  Editor
//
//  Created by Hoon H. on 2014/12/26.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit








///	Creates illusion of immutable text on top of mutable text.
class MultiversionText {
	init(_ source:NSMutableAttributedString) {
		self.source	=	source
		latest	=	Version(source)
	}
	func currentVersion() -> Version {
		return	latest
	}
	func renew() {
		latest.invalidate()
		latest	=	Version(source)
	}
	
	private var source:	NSMutableAttributedString
	private var	latest:	Version
}


extension MultiversionText {
	class Version {
		private init(_ source:NSMutableAttributedString) {
			_source		=	source
		}
		func validity() -> Bool {
			return	_validity
		}
		func invalidate() {
			_validity	=	false
		}
		
		func string() -> String {
			precondition(validity())
			return	_source.string
		}
		func setColor(color: NSColor, range: NSRange) {
			precondition(validity())
			return	_source.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
		}
		
		private var	_validity	=	true
		private let	_source		: NSMutableAttributedString
	}
}