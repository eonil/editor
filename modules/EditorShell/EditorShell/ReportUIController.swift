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




	///

	private func _install() {
		assert(model != nil)

		_scrollV.hasVerticalScroller	=	true
		_scrollV.hasHorizontalScroller	=	true
		_textV.verticallyResizable	=	true
		_textV.horizontallyResizable	=	true

		view.addSubview(_scrollV)
		_scrollV.documentView		=	_textV

		ConsoleModel.Event.Notification.register	(self, ReportingUIController._process)
	}
	private func _deinstall() {
		ConsoleModel.Event.Notification.deregister	(self)

		assert(model != nil)

		_scrollV.documentView		=	nil
		_scrollV.removeFromSuperview()
	}
	private func _layout() {
		assert(model != nil)

		_scrollV.frame			=	view.bounds
	}

	///

	private func _process(n: ConsoleModel.Event.Notification) {
		guard n.sender.workspace === model! else {
			return
		}
		switch n.event {
		case .DidAddLines(let range):
			for i in range {
				let	s	=	n.sender.outputLines[i]
				let	s1	=	NSAttributedString(string: s)
				_textV.textStorage!.appendAttributedString(s1)
			}

		case .DidClear:
			_textV.string	=	nil
		}
	}
}




















