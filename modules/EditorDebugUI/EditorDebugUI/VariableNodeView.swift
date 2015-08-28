//
//  VariableNodeView.swift
//  EditorDebugUI
//
//  Created by Hoon H. on 2015/08/28.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import LLDBWrapper

/// Layout will be controlled by an `NSOutlineView`.
class VariableNodeView: NSTableCellView {

	struct Data {
		var	name 	:	String
		var	type	:	String
		var	value	:	String
	}

	var data: Data? {
		didSet {
			func getExpr() -> String {
				guard data != nil else {
					return	""
				}

				return	"\(data!.name) = \(data!.type) \(data!.value)"

			}
			_exprField.stringValue	=	getExpr()
		}
	}

	///

	private let	_iconView	=	NSImageView()
	private let	_exprField	=	NSTextField()

	private func _install() {
		assert(self.imageView === nil)
		assert(self.textField === nil)
		self.imageView	=	_iconView
		self.textField	=	_exprField
	}
	private func _deinstall() {
		self.textField	=	nil
		self.imageView	=	nil
	}
}






