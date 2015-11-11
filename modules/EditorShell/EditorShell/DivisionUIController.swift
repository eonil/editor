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

class DivisionUIController: CommonViewController {



	///

	weak var model: WorkspaceModel? 
















	///

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

	private let	_sample1	=	DummyViewController()
//	private let	_sample2	=	DummyViewController()
	private let	_sample3	=	DummyViewController()
//	private let	_sample4	=	DummyViewController()

	private let	_nav		=	NavigationUIController()
	private let	_variables	=	FrameVariableTreeUIController()
	private let	_report		=	ReportingUIController()

	private func _install() {
		_report.model		=	model!
		_variables.model	=	model!.debug
		_nav.model		=	model!

		_sample1.view.layer!.backgroundColor	=	NSColor.redColor().CGColor
//		_sample2.view.layer!.backgroundColor	=	NSColor.blueColor().CGColor
		_sample3.view.layer!.backgroundColor	=	NSColor.greenColor().CGColor
//		_sample4.view.layer!.backgroundColor	=	NSColor.purpleColor().CGColor

		_outerSplit.vertical		=	true
		_outerSplit.items		=	[
//			SplitItem(viewController: _contexts),
			SplitItem(viewController: _nav),
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

		Notification<WorkspaceModel,UIState.Event>.register(self, DivisionUIController._process)
	}
	private func _deinstall() {
		Notification<WorkspaceModel,UIState.Event>.deregister(self)

		///

		_outerSplit.view.removeFromSuperview()
		_outerSplit.removeFromParentViewController()

		_nav.model		=	nil
		_variables.model	=	nil
		_report.model		=	nil
	}
	private func _layout() {
		_outerSplit.view.frame			=	view.bounds

	}





	///

	private func _process(n: Notification<WorkspaceModel, UIState.Event>) {
		guard n.sender === model else {
			return
		}
		_applyUIStateChange()
	}
	private func _applyUIStateChange() {
		UIState.ForWorkspaceModel.get(model!) {
			_outerSplit.items[0].isCollapsed	=	$0.navigationPaneVisibility == false
			_innerSplit.items[2].isCollapsed	=	$0.consolePaneVisibility == false
			_outerSplit.items[2].isCollapsed	=	$0.inspectionPaneVisibility == false
		}
	}
	private func _notifyUIStateChange() {
		UIState.ForWorkspaceModel.set(model!) {
			$0.navigationPaneVisibility		=	_outerSplit.items[0].isCollapsed
			$0.consolePaneVisibility		=	_innerSplit.items[2].isCollapsed
			$0.inspectionPaneVisibility		=	_outerSplit.items[2].isCollapsed
		}
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






















