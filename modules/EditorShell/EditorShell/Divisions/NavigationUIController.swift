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

	@objc
	private func EDITOR_onTapFiles() {
		UIState.ForWorkspaceModel.set(model!) {
			$0.navigator	=	.Project
			()
		}
	}
	@objc
	private func EDITOR_onTapDebug() {
		UIState.ForWorkspaceModel.set(model!) {
			$0.navigator	=	.Debug
			()
		}
	}
















	///

	private enum _Mode {
		case Project
		case Debug
	}

	private let _fileTreeToolButton		=	_instantiateScopeButton("Files")
	private let _debuggingToolButton	=	_instantiateScopeButton("Debug")
	private let _modeSelector		=	ToolButtonStrip()
	private let _bottomLine			=	Line()

	private let _fileTreeUI			=	FileTreeUIController()
	private let _debuggingNavigatorUI	=	DebuggingNavigatorUIController()

	private var _mode			=	_Mode.Project









	///

	private func _install() {
		assert(model != nil)

		_fileTreeUI.model		=	model!.file
		_debuggingNavigatorUI.model	=	model!.debug

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
		addChildViewController(_debuggingNavigatorUI)
		view.addSubview(_fileTreeUI.view)
		view.addSubview(_debuggingNavigatorUI.view)

		_fileTreeToolButton.onClick	=	{ [weak self] in self?.EDITOR_onTapFiles() }
		_debuggingToolButton.onClick	=	{ [weak self] in self?.EDITOR_onTapDebug() }

		Notification<WorkspaceModel,UIState.Event>.register	(self, NavigationUIController._process)
	}
	private func _deinstall() {
		assert(model != nil)
		Notification<WorkspaceModel,UIState.Event>.deregister	(self)

		_debuggingNavigatorUI.view.removeFromSuperview()
		_fileTreeUI.view.removeFromSuperview()
		_debuggingNavigatorUI.removeFromParentViewController()
		_fileTreeUI.removeFromParentViewController()

		_modeSelector.removeFromSuperview()
		_bottomLine.removeFromSuperview()
		_modeSelector.toolButtons	=	[]

		_debuggingNavigatorUI.model		=	nil
		_fileTreeUI.model		=	nil
	}
	private func _layout() {
		let	box		=	LayoutBox(view.bounds).autoshrinkingLayoutBox()
		let	modeSelCut	=	box.cutMaxY(30)
		modeSelCut.maxY.applyToView(_modeSelector)
		modeSelCut.maxY.applyToView(_bottomLine)
		modeSelCut.rest.applyToView(_fileTreeUI.view)
		modeSelCut.rest.applyToView(_debuggingNavigatorUI.view)
	}





















	///

	private func _process(n: Notification<WorkspaceModel, UIState.Event>) {
		guard n.sender === model! else {
			return
		}
//		switch n.event {
//		case .Initiate:
//		case .Invalidate:
//		case .Terminate:
//		}

		let	oldMode	=	_mode
		UIState.ForWorkspaceModel.get(model!) { state in
			_mode	=	{
				switch state.navigator {
				case .Project:	return	.Project
				case .Debug:	return	.Debug
				}
			}() as _Mode

		}
		if oldMode != _mode {
			_applyModeSelectionChange()
		}
	}


	private func _applyModeSelectionChange() {
		switch _mode {
		case .Project:
			_fileTreeToolButton.selected		=	true
			_debuggingToolButton.selected		=	false
			_fileTreeUI.view.hidden			=	false
			_debuggingNavigatorUI.view.hidden	=	true
			view.window!.makeFirstResponder(_fileTreeUI)

		case .Debug:
			_fileTreeToolButton.selected		=	false
			_debuggingToolButton.selected		=	true
			_fileTreeUI.view.hidden			=	true
			_debuggingNavigatorUI.view.hidden	=	false
			view.window!.makeFirstResponder(_debuggingNavigatorUI)

		}
	}








}




































private func _instantiateScopeButton(title: String) -> ScopeButton {
	let	v	=	ScopeButton()
	v.onShouldChangeSelectionStateByUserClick	=	{ [weak v] in
		guard let v = v else {
			return	false
		}
		return	v.selected == false
	}
	v.title		=	title
	v.titleFont	=	NSFont.systemFontOfSize(NSFont.systemFontSizeForControlSize(.SmallControlSize))
	v.sizeToFit()
	return	v
}
//private func _instantiateScopeButton(title: String) -> NSButton {
//	let	sz	=	NSControlSize.SmallControlSize
//	let	v	=	NSButton()
//	v.font		=	NSFont.systemFontOfSize(NSFont.systemFontSizeForControlSize(sz))
//	v.controlSize	=	sz
//	v.title		=	title
//	v.bezelStyle	=	NSBezelStyle.RecessedBezelStyle
//	v.state		=	NSOffState
//	v.highlighted	=	false
//	v.showsBorderOnlyWhileMouseInside	=	true
//	v.setButtonType(NSButtonType.PushOnPushOffButton)
//	v.sizeToFit()
//	v.wantsLayer	=	true
//	return	v
//}





