//
//  ReportUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import MulticastingStorage
import EditorCommon
import EditorModel
import EditorUICommon

class ReportingUIController: CommonViewController {

	weak var model: WorkspaceModel?

	///

	override func installSubcomponents() {
		super.installSubcomponents()
		_install()
		_layout()
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

	private let	_scrollV	=	NSScrollView()
	private let	_textV		=	NSTextView()

	private let	_consoleLineA	=	_ConsoleLineAgent()

	///

	private func _install() {
		assert(model != nil)

		_scrollV.hasVerticalScroller	=	true
		_scrollV.hasHorizontalScroller	=	true
		_textV.verticallyResizable	=	true
		_textV.horizontallyResizable	=	true

		view.addSubview(_scrollV)
		_scrollV.documentView		=	_textV

		_consoleLineA.owner		=	self
		model!.console.outputLines.register(_consoleLineA)
	}
	private func _deinstall() {
		model!.console.outputLines.deregister(_consoleLineA)
		_consoleLineA.owner		=	nil

		assert(model != nil)

		_scrollV.documentView		=	nil
		_scrollV.removeFromSuperview()
	}
	private func _layout() {
		assert(model != nil)

		_scrollV.frame			=	view.bounds
	}

	///

	private func _handleDidInsertConsoleLinesInRange(range: Range<Int>) {
		for line in model!.console.outputLines.array[range] {
			let	s	=	NSAttributedString(string: line)
			_textV.textStorage!.appendAttributedString(s)
		}
	}
	private func _handleDidDeleteConsoleLinesInRange(range: Range<Int>) {
		if range.startIndex == model!.console.outputLines.array.startIndex && range.endIndex == model!.console.outputLines.array.endIndex {
			assert(_textV.textStorage != nil)
			if let ts = _textV.textStorage {
				let	r	=	NSRange(location: 0, length: (ts.string as NSString).length)
				ts.deleteCharactersInRange(r)
			}
		}
		else {
			markUnimplemented()
			fatalErrorBecauseUnimplementedYet()
		}
	}
}












private final class _ConsoleLineAgent: ArrayStorageDelegate {
	weak var owner: ReportingUIController?

	private func willInsertRange(range: Range<Int>) {
	}
	private func didInsertRange(range: Range<Int>) {
		owner!._handleDidInsertConsoleLinesInRange(range)
	}
	private func willUpdateRange(range: Range<Int>) {
	}
	private func didUpdateRange(range: Range<Int>) {
		markUnimplemented()
		fatalErrorBecauseUnimplementedYet()
	}
	private func willDeleteRange(range: Range<Int>) {
	}
	private func didDeleteRange(range: Range<Int>) {
		owner!._handleDidDeleteConsoleLinesInRange(range)
	}
}













