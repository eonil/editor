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

	struct Data {
		var	icon	:	NSImage?
		var	text	:	String?
	}

	var data: Data? {
		didSet {
			_iconView.image		=	data?.icon
			_exprField.stringValue	=	data?.text ?? ""
		}
	}

//	weak var model: FileNodeModel? {
//		willSet {
//			assert(window == nil)
//		}
//	}

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



//		_didSetPath()
//		model!.path.registerDidSet(ObjectIdentifier(self)) { [weak self] in
//			self!._didSetPath()
//		}
//		model!.path.registerWillSet(ObjectIdentifier(self)) { [weak self] in
//			self!._willSetPath()
//		}
	}
	private func _deinstall() {
//		model!.path.deregisterDidSet(ObjectIdentifier(self))
//		model!.path.deregisterWillSet(ObjectIdentifier(self))
//		_willSetPath()

		_exprField.removeFromSuperview()
		_iconView.removeFromSuperview()
		self.textField	=	nil
		self.imageView	=	nil
	}

//	private func _didSetPath() {
//		_exprField.stringValue	=	model!.path.value?.parts.last ?? ""
//	}
//	private func _willSetPath() {
//	}
}










