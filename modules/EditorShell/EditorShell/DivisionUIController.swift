//
//  DivisionUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel
import EditorUICommon
import EditorFileUI
import EditorDebugUI

class DivisionUIController: CommonUIController {

	weak var model: WorkspaceModel? {
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

	private let	_outerSplit	=	SplitViewController()
	private let	_innerSplit	=	SplitViewController()
	private let	_edit		=	EditUIController()

	private let	_sample1	=	DummyUIController()
//	private let	_sample2	=	DummyUIController()
	private let	_sample3	=	DummyUIController()
//	private let	_sample4	=	DummyUIController()

	private let	_files		=	FileTreeUIController()
	private let	_contexts	=	ContextTreeUIController()
	private let	_variables	=	VariableTreeUIController()
	private let	_report		=	ReportingUIController()

	private func _install() {
		_files.model		=	model!.file
		_report.model		=	model!
		_contexts.model		=	model!.debug
		_variables.model	=	model!.debug

		_sample1.view.layer!.backgroundColor	=	NSColor.redColor().CGColor
//		_sample2.view.layer!.backgroundColor	=	NSColor.blueColor().CGColor
		_sample3.view.layer!.backgroundColor	=	NSColor.greenColor().CGColor
//		_sample4.view.layer!.backgroundColor	=	NSColor.purpleColor().CGColor

		_outerSplit.vertical		=	true
		_outerSplit.items		=	[
//			SplitItem(viewController: _contexts),
			SplitItem(viewController: _files),
			SplitItem(viewController: _innerSplit),
			SplitItem(viewController: _variables),
		]

		_innerSplit.vertical		=	false
		_innerSplit.items		=	[
			SplitItem(viewController: _sample3),
			SplitItem(viewController: _edit),
			SplitItem(viewController: _report),
		]

		addChildViewController(_outerSplit)
		view.addSubview(_outerSplit.view)

		///

		_installHandlers()
	}
	private func _deinstall() {
		_deinstallHandlers()

		_outerSplit.view.removeFromSuperview()
		_outerSplit.removeFromParentViewController()

		_variables.model	=	nil
		_contexts.model		=	nil
		_report.model		=	nil
		_files.model		=	nil

	}
	private func _layout() {
		_outerSplit.view.frame			=	view.bounds

	}


	private func _installHandlers() {
		_applyNavigationPaneDisplayState()
		model!.UI.navigationPane.registerDidSet(ObjectIdentifier(self)) { [weak self] in
			self?._applyNavigationPaneDisplayState()
		}
		model!.UI.consolePane.registerDidSet(ObjectIdentifier(self)) { [weak self] in
			self?._applyNavigationPaneDisplayState()
		}
		model!.UI.inspectionPane.registerDidSet(ObjectIdentifier(self)) { [weak self] in
			self?._applyNavigationPaneDisplayState()
		}
	}
	private func _deinstallHandlers() {
		model!.UI.navigationPane.deregisterDidSet(ObjectIdentifier(self))
		model!.UI.consolePane.deregisterDidSet(ObjectIdentifier(self))
		model!.UI.inspectionPane.deregisterDidSet(ObjectIdentifier(self))
		_applyNavigationPaneDisplayState()
	}

	private func _applyNavigationPaneDisplayState() {
		_outerSplit.items[0].isCollapsed	=	model!.UI.navigationPane.value == false
		_innerSplit.items[2].isCollapsed	=	model!.UI.consolePane.value == false
		_outerSplit.items[2].isCollapsed	=	model!.UI.inspectionPane.value == false
	}
}

/////	`NSSplitController` Seems to be a class cluster, because subclassing does not provide expected behavior.
/////	Anyway, 10.11 seem to have min/preferred size stuffs, so just wait for the release.
/////
//private final class _DivisionSplitViewController: NSSplitViewController {
//	weak var owner: DivisionUIController?
//	@objc
//	private override func splitView(splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
//		switch  dividerIndex {
//		case 0:
//			return	100
//
//		case splitView.subviews.count-2:
//			return	splitView.bounds.maxX - 100
//
//		default:
//			return	proposedMinimumPosition
//		}
//	}
//}






















