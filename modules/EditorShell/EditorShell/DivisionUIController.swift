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
	private let	_sample2	=	DummyUIController()
	private let	_sample3	=	DummyUIController()
	private let	_sample4	=	DummyUIController()

	private func _install() {
		_sample1.view.layer!.backgroundColor	=	NSColor.redColor().CGColor
		_sample2.view.layer!.backgroundColor	=	NSColor.blueColor().CGColor
		_sample3.view.layer!.backgroundColor	=	NSColor.greenColor().CGColor
		_sample4.view.layer!.backgroundColor	=	NSColor.purpleColor().CGColor

		_outerSplit.vertical		=	true
		_outerSplit.items		=	[
			SplitItem(viewController: _sample1),
			SplitItem(viewController: _innerSplit),
			SplitItem(viewController: _sample2),
		]

		_innerSplit.vertical		=	false
		_innerSplit.items		=	[
			SplitItem(viewController: _sample3),
			SplitItem(viewController: _edit),
			SplitItem(viewController: _sample4),
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

	}
	private func _layout() {
		_outerSplit.view.frame			=	view.bounds

	}


	private func _installHandlers() {
		model!.UI.navigationPane.registerDidSet(ObjectIdentifier(self)) { [weak self] in
			self?._applyNavigationPaneDisplayState()
		}
	}
	private func _deinstallHandlers() {
		model!.UI.navigationPane.deregisterDidSet(ObjectIdentifier(self))
	}

	private func _applyNavigationPaneDisplayState() {
		_outerSplit.items[0].isCollapsed	=	model!.UI.navigationPane.value
		_innerSplit.items[2].isCollapsed	=	model!.UI.consolePane.value
		_outerSplit.items[2].isCollapsed	=	model!.UI.inspectionPane.value
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






















