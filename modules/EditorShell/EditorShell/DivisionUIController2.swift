//
//  DivisionUIController2.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/12.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorModel
import EditorUICommon

class DivisionUIController2: CommonViewController {









	///

	weak var model: WorkspaceModel? {
		didSet {
			_navigationVC.model	=	model
			_reportingVC.model	=	model
//			_inspectionVC.model	=	model
			_editingVC.model	=	model
		}
	}














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









	///

	private class _DarkSplitView: NSSplitView {
		override var dividerColor: NSColor {
			get {
				return	WindowDivisionSplitDividerColor
			}
		}
	}
	private class _DarkSplitViewController: NSSplitViewController {
		override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
			super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
			let	v		=	_DarkSplitView()
			v.translatesAutoresizingMaskIntoConstraints	=	false
			v.vertical					=	true
			v.dividerStyle					=	.Thin
			splitView		=	v
		}
		required init?(coder: NSCoder) {
			fatalError()
		}
		private override func viewDidLoad() {
			super.viewDidLoad()
		}
	}

	private let _outerSplitVC		=	_DarkSplitViewController()
	private let _innerSplitVC		=	_DarkSplitViewController()

	private let _outerLeftSplitItem		=	NSSplitViewItem()
	private let _outerRightSplitItem	=	NSSplitViewItem()
	private let _innerTopSplitItem		=	NSSplitViewItem()
	private let _innerBottomSplitItem	=	NSSplitViewItem()

	private let _navigationVC		=	NavigationUIController()
	private let _reportingVC		=	ReportingUIController()
	private let _inspectionVC		=	DummyViewController()
	private let _editingVC			=	EditUIController()

	private var _splitItems			:	(outer: (left: NSSplitViewItem, right: NSSplitViewItem), inner: (top: NSSplitViewItem, bottom: NSSplitViewItem))?
	private var _collapsingState		:	(outer: (left: Bool, right: Bool), inner: (top: Bool, bottom: Bool))?

//	private var _splitItemMapping		=	Dictionary<ReferentialIdentity<NSViewController>, NSSplitView>()

	private func _install() {
		// Initial metrics defines initial layout. We need these.
		_navigationVC.view.frame.size.width	=	200
		_inspectionVC.view.frame.size.width	=	200
		_reportingVC.view.frame.size.height	=	100

		func navItem() -> NSSplitViewItem {
			let	m	=	NSSplitViewItem(sidebarWithViewController: _navigationVC)
			m.minimumThickness		=	100
			m.preferredThicknessFraction	=	0.1
			m.automaticMaximumThickness	=	100
			m.canCollapse			=	true
			return	m
		}
		func inspItem() -> NSSplitViewItem {
			let	m	=	NSSplitViewItem(contentListWithViewController: _inspectionVC)
			m.minimumThickness		=	100
			m.preferredThicknessFraction	=	0.1
			m.automaticMaximumThickness	=	100
			m.canCollapse			=	true
			return	m
		}
		func centerItem() -> NSSplitViewItem {
			let	m	=	NSSplitViewItem(viewController: _innerSplitVC)
			m.minimumThickness		=	100
			m.preferredThicknessFraction	=	0.8
			m.automaticMaximumThickness	=	NSSplitViewItemUnspecifiedDimension
			return	m
		}
		func reportItem() -> NSSplitViewItem {
			let	m	=	NSSplitViewItem(viewController: _reportingVC)
			m.minimumThickness		=	100
			m.preferredThicknessFraction	=	0.1
			m.automaticMaximumThickness	=	100
			m.canCollapse			=	true
			return	m
		}
		func editItem() -> NSSplitViewItem {
			let	m	=	NSSplitViewItem(viewController: _editingVC)
			m.minimumThickness		=	100
			m.preferredThicknessFraction	=	0.9
			m.automaticMaximumThickness	=	NSSplitViewItemUnspecifiedDimension
			return	m
		}


		_splitItems	=	(
			outer:
				(left:	navItem(),
				right:	inspItem()),
			inner:
				(top:	editItem(),
				bottom:	reportItem()))

		_innerSplitVC.splitView.vertical	=	false
		_innerSplitVC.splitViewItems		=	[
			_splitItems!.inner.top,
			_splitItems!.inner.bottom,
		]
		_outerSplitVC.splitViewItems		=	[
			_splitItems!.outer.left,
			centerItem(),
			_splitItems!.outer.right,
		]
		addChildViewController(_outerSplitVC)
		view.addSubview(_outerSplitVC.view)

		NSNotificationCenter.defaultCenter().addUIObserver	(self, DivisionUIController2._process, NSSplitViewDidResizeSubviewsNotification)
		UIState.ForWorkspaceModel.Notification.register		(self, DivisionUIController2._process)
	}
	private func _deinstall() {
		UIState.ForWorkspaceModel.Notification.deregister	(self)
		NSNotificationCenter.defaultCenter().removeUIObserver	(self, NSSplitViewDidResizeSubviewsNotification)

		_outerSplitVC.view.removeFromSuperview()
		_outerSplitVC.removeFromParentViewController()
		_outerSplitVC.splitViewItems		=	[]
		_innerSplitVC.splitViewItems		=	[]
		_splitItems				=	nil
	}
	private func _layout() {
		_outerSplitVC.view.frame		=	view.bounds
	}
















	/// 

	private func _getCollapsingState() -> (outer: (left: Bool, right: Bool), inner: (top: Bool, bottom: Bool)) {
		return	(
			(_splitItems!.outer.left.collapsed, _splitItems!.outer.right.collapsed),
			(_splitItems!.inner.top.collapsed, _splitItems!.inner.bottom.collapsed))
	}
	private func _process(n: NSNotification) {
		guard n.object === _outerSplitVC.splitView || n.object === _innerSplitVC.splitView else {
			return
		}

		switch n.name {
		case NSSplitViewDidResizeSubviewsNotification:
			let	oldState	=	_collapsingState ?? _getCollapsingState()
			let	newState	=	_getCollapsingState()
			let	noChange	=	newState.outer.left == oldState.outer.left
						&&	newState.outer.right == oldState.outer.right
						&&	newState.inner.top == oldState.inner.top
						&&	newState.inner.bottom == oldState.inner.bottom

			if noChange == false {
				_applyInputToState()
			}

			_collapsingState	=	newState

		default:
			fatalError()
		}
	}













	///

	private func _applyInputToState() {
		UIState.ForWorkspaceModel.set(model!) {
			$0.navigationPaneVisibility	=	_splitItems!.outer.left.collapsed == false
			$0.inspectionPaneVisibility	=	_splitItems!.outer.right.collapsed == false
			$0.consolePaneVisibility	=	_splitItems!.inner.bottom.collapsed == false
		}
	}










	///

	private func _process(n: UIState.ForWorkspaceModel.Notification) {
		guard model === n.sender else {
			return
		}
		_applyStateChanges()
	}
	private func _applyStateChanges() {
		UIState.ForWorkspaceModel.get(model!) {
			_splitItems!.outer.left.collapsed	=	$0.navigationPaneVisibility == false
			_splitItems!.outer.right.collapsed	=	$0.inspectionPaneVisibility == false
			_splitItems!.inner.bottom.collapsed	=	$0.consolePaneVisibility == false
		}
	}


}







































//private class _ObserveableSplitViewController: NSSplitViewController {
//	var onWillResizeSubviews: (()->())?
//	var onDidResizeSubviews: (()->())?
//	private func splitViewWillResizeSubviews(notification: NSNotification) {
//		super.splitViewWillResizeSubviews(notification)
//	}
//	private override func splitViewDidResizeSubviews(notification: NSNotification) {
//		onDidResizeSubviews?()
//		super.splitViewDidResizeSubviews(notification)
//	}
//}








