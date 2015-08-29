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

				return	"\(data!.name) = (\(data!.type)) \(data!.value)"

			}
			_exprField.stringValue	=	getExpr()
		}
	}

	///

	override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		if window != nil {
			_install()
		}
	}
	override func viewWillMoveToWindow(newWindow: NSWindow?) {
		if window != nil {
			_deinstall()
		}
		super.viewWillMoveToWindow(newWindow)
	}

	///

	private let	_iconView	=	NSImageView()
	private let	_exprField	=	CommonComponentFactory.instantiateNodeTextField()

	private func _install() {
		assert(self.imageView === nil)
		assert(self.textField === nil)
		self.imageView	=	_iconView
		self.textField	=	_exprField
		addSubview(_iconView)
		addSubview(_exprField)
	}
	private func _deinstall() {
		_exprField.removeFromSuperview()
		_iconView.removeFromSuperview()
		self.textField	=	nil
		self.imageView	=	nil
	}
}






