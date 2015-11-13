//
//  EditTextFileUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/12.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel
import EditorUICommon

class EditTextFileUIController: CommonViewController {

	var string: String? {
		willSet {
			if let _ = string {
				_textView.string	=	""
			}
		}
		didSet {
			if let string = string {
				let	s1		=	NSAttributedString(string: string, attributes: _textView.typingAttributes)
				_textView.textStorage!.appendAttributedString(s1)
			}
		}
	}

	override func installSubcomponents() {
		super.installSubcomponents()
		_install()
	}
	override func deinstallSubcomponents() {
		_deinstall()
		super.deinstallSubcomponents()
	}
	override func layoutSubcomponents() {
		super.layoutSubcomponents()
		_layout()
	}








	///

	private let _scrollView			=	_instantiateScrollView()
	private let _textView			=	_instantiateTextView()

	private func _install() {
		view.addSubview(_scrollView)
		_scrollView.documentView	=	_textView
	}
	private func _deinstall() {
		_scrollView.documentView	=	nil
		_scrollView.removeFromSuperview()
	}
	private func _layout() {
		_scrollView.frame		=	view.bounds
	}

}













private func _instantiateScrollView() -> NSScrollView {
	return	CommonViewFactory.instantiateScrollViewForCodeDisplayTextView()
}

private func _instantiateTextView() -> NSTextView {
	return	CommonViewFactory.instantiateTextViewForCodeDisplay()
}






