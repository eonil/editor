//
//  NavigationUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel
import EditorUICommon

class NavigationUIController: CommonViewController {




	weak var model: WorkspaceModel?








	///

	override func installSubcomponents() {
		super.installSubcomponents()
		_install()
		_layout()
		_applyModeSelectionChange()
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

	private enum _Mode {
		case Files
		case Debug
	}

	private let _fileTreeToolButton		=	_instantiateScopeButton("Files")
	private let _debuggingToolButton	=	_instantiateScopeButton("Debug")
	private let _modeSelector		=	ToolButtonStrip()
	private let _bottomLine			=	Line()

	private let _fileTreeUI			=	FileTreeUIController()
	private let _contextTreeUI		=	ContextTreeUIController()

	private var _mode			=	_Mode.Files





	///

	private func _install() {
		assert(model != nil)
		_fileTreeUI.model		=	model!.file
		_contextTreeUI.model		=	model!.debug

		_bottomLine.position		=	.MinY
		_bottomLine.lineColor		=	NSColor.gridColor()
		view.addSubview(_bottomLine)

		_modeSelector.interButtonGap	=	2
		_modeSelector.toolButtons	=	[
			_fileTreeToolButton,
			_debuggingToolButton,
		]
		view.addSubview(_modeSelector)

		addChildViewController(_fileTreeUI)
		addChildViewController(_contextTreeUI)
		view.addSubview(_fileTreeUI.view)
		view.addSubview(_contextTreeUI.view)


		_fileTreeToolButton.target	=	self
		_fileTreeToolButton.action	=	"EDITOR_onTapFiles"

		_debuggingToolButton.target	=	self
		_debuggingToolButton.action	=	"EDITOR_onTapDebug"
	}
	private func _deinstall() {
		assert(model != nil)

		_contextTreeUI.view.removeFromSuperview()
		_fileTreeUI.view.removeFromSuperview()
		_contextTreeUI.removeFromParentViewController()
		_fileTreeUI.removeFromParentViewController()

		_modeSelector.removeFromSuperview()
		_bottomLine.removeFromSuperview()
		_modeSelector.toolButtons	=	[]

		_contextTreeUI.model		=	nil
		_fileTreeUI.model		=	nil
	}
	private func _layout() {
		let	box		=	LayoutBox(view.bounds).autoshrinkingLayoutBox()
		let	modeSelCut	=	box.cutMaxY(30)
		modeSelCut.maxY.applyToView(_modeSelector)
		modeSelCut.maxY.applyToView(_bottomLine)
		modeSelCut.rest.applyToView(_fileTreeUI.view)
		modeSelCut.rest.applyToView(_contextTreeUI.view)
	}
	private func _applyModeSelectionChange() {
		switch _mode {
		case .Files:
			_fileTreeUI.view.hidden		=	false
			_fileTreeToolButton.state	=	NSOnState
			_contextTreeUI.view.hidden	=	true
			_debuggingToolButton.state	=	NSOffState

		case .Debug:
			_fileTreeUI.view.hidden		=	true
			_fileTreeToolButton.state	=	NSOffState
			_contextTreeUI.view.hidden	=	false
			_debuggingToolButton.state	=	NSOnState

		}
	}










	///

	@objc
	private func EDITOR_onTapFiles() {
		_mode	=	.Files
		_applyModeSelectionChange()
	}
	@objc
	private func EDITOR_onTapDebug() {
		_mode	=	.Debug
		_applyModeSelectionChange()
	}
}





































private func _instantiateScopeButton(title: String) -> NSButton {
	let	sz	=	NSControlSize.SmallControlSize
	let	v	=	NSButton()
	v.font		=	NSFont.systemFontOfSize(NSFont.systemFontSizeForControlSize(sz))
	v.controlSize	=	sz
	v.title		=	title
	v.bezelStyle	=	NSBezelStyle.RecessedBezelStyle
	v.state		=	NSOffState
	v.highlighted	=	false
	v.showsBorderOnlyWhileMouseInside	=	true
	v.setButtonType(NSButtonType.PushOnPushOffButton)
	v.sizeToFit()
	return	v
}





