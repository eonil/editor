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

	private func _onTapProjectPaneButton() {
		model!.overallUIState.paneSelection	=	WorkspaceUIState.Pane.Navigation(.Project)
	}
	private func _onTapIssuePaneButton() {
		model!.overallUIState.paneSelection	=	WorkspaceUIState.Pane.Navigation(.Issue)
	}
	private func _onTapDebugPaneButton() {
		model!.overallUIState.paneSelection	=	WorkspaceUIState.Pane.Navigation(.Debug)
	}
















	///

	private enum _Mode {
		case Project
		case Issue
		case Debug
	}

	private let _fileTreeToolButton		=	_instantiateScopeButton("Files")
	private let _issueListToolButton	=	_instantiateScopeButton("Issues")
	private let _debuggingToolButton	=	_instantiateScopeButton("Debug")
	private let _modeSelector		=	ToolButtonStrip()
	private let _bottomLine			=	Line()

	private let _fileTreeUI			=	FileTreeUIController()
	private let _issueListUI		=	IssueListUIController()
	private let _debuggingNavigatorUI	=	DebuggingNavigatorUIController()

	private var _mode			=	_Mode.Project









	///

	private func _install() {
		assert(model != nil)

		_fileTreeUI.model		=	model!.file
		_issueListUI.model		=	model!.report
		_debuggingNavigatorUI.model	=	model!.debug

		_bottomLine.position		=	.MinY
		_bottomLine.lineColor		=	NSColor.gridColor()
		view.addSubview(_bottomLine)

		_modeSelector.interButtonGap	=	2
		_modeSelector.toolButtons	=	[
			_fileTreeToolButton,
			_issueListToolButton,
			_debuggingToolButton,
		]
		view.addSubview(_modeSelector)

		addChildViewController(_fileTreeUI)
		view.addSubview(_fileTreeUI.view)

		addChildViewController(_issueListUI)
		view.addSubview(_issueListUI.view)

		addChildViewController(_debuggingNavigatorUI)
		view.addSubview(_debuggingNavigatorUI.view)

		_fileTreeToolButton.onClick	=	{ [weak self] in self?._onTapProjectPaneButton() }
		_issueListToolButton.onClick	=	{ [weak self] in self?._onTapIssuePaneButton() }
		_debuggingToolButton.onClick	=	{ [weak self] in self?._onTapDebugPaneButton() }

		Notification<WorkspaceModel,UIState.Event>.register	(self, NavigationUIController._process)
	}
	private func _deinstall() {
		assert(model != nil)
		Notification<WorkspaceModel,UIState.Event>.deregister	(self)

		_debuggingNavigatorUI.view.removeFromSuperview()
		_debuggingNavigatorUI.removeFromParentViewController()

		_issueListUI.view.removeFromSuperview()
		_issueListUI.removeFromParentViewController()

		_fileTreeUI.view.removeFromSuperview()
		_fileTreeUI.removeFromParentViewController()

		_modeSelector.removeFromSuperview()
		_bottomLine.removeFromSuperview()
		_modeSelector.toolButtons	=	[]

		_debuggingNavigatorUI.model	=	nil
		_issueListUI.model		=	nil
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

		switch model!.overallUIState.paneSelection {
		case .Editor:
			break

		case .Navigation(let nav):
			_mode	=	{
				switch nav {
				case .Project:
					return	.Project
				case .Issue:
					return	.Issue
				case .Debug:
					return	.Debug
				}
				}() as _Mode
		}
		if oldMode != _mode {
			_applyModeSelectionChange()
		}
	}


	private func _applyModeSelectionChange() {
		func setVisibility(visibleButton: ScopeButton, visibleViewController: NSViewController) {
			_fileTreeToolButton.selected		=	visibleButton === _fileTreeToolButton
			_issueListToolButton.selected		=	visibleButton === _issueListToolButton
			_debuggingToolButton.selected		=	visibleButton === _debuggingToolButton
			_fileTreeUI.view.hidden			=	visibleViewController !== _fileTreeUI
			_issueListUI.view.hidden		=	visibleViewController !== _issueListUI
			_debuggingNavigatorUI.view.hidden	=	visibleViewController !== _debuggingNavigatorUI
		}

		switch _mode {
		case .Project:
			setVisibility(_fileTreeToolButton, visibleViewController: _fileTreeUI)
			view.window!.makeFirstResponder(_fileTreeUI)

		case .Issue:
			setVisibility(_issueListToolButton, visibleViewController: _issueListUI)
			view.window!.makeFirstResponder(_issueListUI)

		case .Debug:
			setVisibility(_debuggingToolButton, visibleViewController: _debuggingNavigatorUI)
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





class IssueListUIController: CommonViewController {
	weak var model: ReportingModel?
}
