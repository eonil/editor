//
//  ContextNodeView.swift
//  EditorDebugUI
//
//  Created by Hoon H. on 2015/08/28.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit


final class ProcessNodeView: ContextNodeView {
	weak var model: ProcessNode? {
		willSet {
		}
		didSet {
			_exprField.stringValue	=	model?.data == nil ? "(none)" : "Process: #\(model!.data!.processID)"
		}
	}
}

final class ThreadNodeView: ContextNodeView {
	weak var model: ThreadNode? {
		willSet {
		}
		didSet {
			_exprField.stringValue	=	model?.data == nil ? "(none)" : "Thread: \(model!.data!.name) #\(model!.data!.threadID)"
		}
	}
}

final class FrameNodeView: ContextNodeView {
	weak var model: FrameNode? {
		willSet {
		}
		didSet {
			_exprField.stringValue	=	model?.data == nil ? "(none)" : "\(model!.data!.frameID) #\(model!.data!.functionName)"
		}
	}
}




















class ContextNodeView: NSTableCellView {

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
	private let	_exprField	=	_instantiateTextField()

	private func _install() {
		assert(self.imageView === nil)
		assert(self.textField === nil)
		self.imageView	=	_iconView
		self.textField	=	_exprField
		addSubview(_iconView)
		addSubview(_exprField)
	}
	private func _deinstall() {
		_iconView.removeFromSuperview()
		_exprField.removeFromSuperview()
		self.textField	=	nil
		self.imageView	=	nil
	}

}









private func _instantiateTextField() -> NSTextField {
	let	v		=	NSTextField()
	v.bezeled		=	false
	v.backgroundColor	=	NSColor.clearColor()
	return	v
}







