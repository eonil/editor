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

	var location: NSURL? {
		willSet {

		}
		didSet {

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

	private let _scrollView		=	_instantiateScrollView()
	private let _textView		=	_instantiateTextView()

	private func _install() {
		view.addSubview(_scrollView)
		_scrollView.documentView	=	_textView
	}
	private func _deinstall() {
		_scrollView.documentView	=	nil
		_scrollView.removeFromSuperview()
	}
	private func _layout() {
		_scrollView.frame	=	view.bounds
	}

}













private func _instantiateScrollView() -> NSScrollView {
	let	v	=	NSScrollView()
	v.hasHorizontalScroller	=	true
	v.hasVerticalScroller	=	true
	return	v
}

private func _instantiateTextView() -> NSTextView {
	let	v	=	NSTextView()
	v.verticallyResizable	=	true
	v.horizontallyResizable	=	true
	return	v
}






