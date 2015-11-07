//
//  DivisionSplitViewController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit


public final class SplitItem {
	public init(viewController: NSViewController) {
		self.viewController	=	viewController
	}
	public let viewController: NSViewController
	public var canCollapse: Bool = false {
		didSet {

		}
	}
	public var isCollapsed: Bool = false {
		didSet {
			_owner!._applyCollapsingStateOfItem(self)
		}
	}

	///

	private weak var _owner: SplitViewController?
}

public final class SplitViewController: CommonViewController, NSSplitViewDelegate {

	public var vertical: Bool {
		get {
			return	_splitV.vertical
		}
		set {
			_splitV.vertical	=	newValue
		}
	}

	public var items: [SplitItem] = [] {
		willSet {
			_deinstallItems()
		}
		didSet {
			_installItems()
		}
	}


	public override func installSubcomponents() {
		super.installSubcomponents()
		_install()
	}
	public override func deinstallSubcomponents() {
		_deinstall()
		super.deinstallSubcomponents()
	}
	public override func layoutSubcomponents() {
		super.layoutSubcomponents()
		_layout()
	}

	///

	private let	_splitV		=	NSSplitView()

	private func _install() {
		_splitV.delegate	=	self
		view.addSubview(_splitV)
	}
	private func _deinstall() {
		_splitV.removeFromSuperview()
		_splitV.delegate	=	nil
	}
	private func _layout() {
		_splitV.frame	=	view.bounds
	}

	private func _installItems() {
		for item in items {
			assert(item._owner === nil)
			item._owner	=	self

			addChildViewController(item.viewController)
			_splitV.addSubview(item.viewController.view)
		}
	}
	private func _deinstallItems() {
		for item in items {
			assert(item._owner === self)
			assert(item.viewController.view.superview === _splitV)

			item.viewController.view.removeFromSuperview()
			item.viewController.removeFromParentViewController()

			item._owner	=	nil
		}
	}
	private func _applyCollapsingStateOfItem(item: SplitItem) {
		guard item.viewController.view.hidden != item.isCollapsed else {
			return
		}

		item.viewController.view.hidden	=	item.isCollapsed
		_splitV.adjustSubviews()
	}
}







