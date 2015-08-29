//
//  FileNodeView.swift
//  EditorFileUI
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import MulticastingStorage
import EditorModel

class FileNodeView: NSTableCellView {

	weak var model: FileNodeModel? {
		willSet {
			assert(window == nil)
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

		_exprField.stringValue	=	model!.path.value?.parts.last ?? "AA"
	}
	private func _deinstall() {
		_exprField.stringValue	=	""

		_exprField.removeFromSuperview()
		_iconView.removeFromSuperview()
		self.textField	=	nil
		self.imageView	=	nil
	}
}










