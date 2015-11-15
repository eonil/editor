//
//  MenuItemController.swift
//  EditorUICommon
//
//  Created by Hoon H. on 2015/11/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon


/// Wraps `NSMenuItem` to provide a better interface.
///
/// - Gains ensure on instance behaviors. `NSMenuItem` implementation is
///   total black-box. For example, we don't know how equality comparison
///   would work, and so on.
/// - Limits possible mutators. (though it's just an illusion...)
/// - Provides convenient add submenu method.
/// - Provides better debug description.
///
public class MenuItemController {
	public func addSubmenuItems(subitemControllers: [MenuItemController]) {
		guard _cocoaMenuItem.submenu != nil else {
			fatalError("Current menu item is not intended to be a group. Please review the code.")
		}
		for itemController in subitemControllers {
			_cocoaMenuItem.submenu!.addItem(itemController._cocoaMenuItem)
		}
		_subcontrollers.appendContentsOf(subitemControllers)
	}







	///

	public init(menuItem: NSMenuItem = NSMenuItem()) {
		_cocoaMenuItem		=	menuItem
		_cocoaMenuItem.enabled	=	false
		_cocoaMenuAgent.owner	=	self
		_cocoaMenuItem.target	=	_cocoaMenuAgent
		_cocoaMenuItem.action	=	Selector("EDITOR_onClick:")
	}
	deinit {
		_cocoaMenuItem.target	=	nil
		_cocoaMenuItem.action	=	nil
		_cocoaMenuAgent.owner	=	nil
	}








	///

	public var menuItem: NSMenuItem {
		get {
			return	_cocoaMenuItem
		}
	}
	public var enabled: Bool {
		get {
			return	_cocoaMenuItem.enabled
		}
		set {
			_cocoaMenuItem.enabled	=	newValue
		}
	}
	public var onClick: (() -> ())? {
		get {
			return	_onClick
		}
		set {
			_onClick	=	newValue
		}
	}






	///

	private var	_onClick	:	(() -> ())?
	private let	_cocoaMenuItem	:	NSMenuItem
	private let	_cocoaMenuAgent	=	_MenuItemAgent()
	private var	_subcontrollers	=	[MenuItemController]()
}
extension MenuItemController: CustomStringConvertible, CustomDebugStringConvertible {
	public var description: String {
		get {
			var	names	=	[String]()
			var	m	=	_cocoaMenuItem.menu
			while let m1 = m {
				names.insert(m1.title, atIndex: 0)
				m	=	m?.supermenu
			}
			names.append(_cocoaMenuItem.title)
			return	names.map({"[\($0)]"}).joinWithSeparator(" -> ")
		}
	}
	public var debugDescription: String {
		get {
			return	description
		}
	}
}
extension MenuItemController {
	public static func groupMenuItem(title: String) -> MenuItemController {
		let	sm		=	NSMenu(title: title)
		sm.autoenablesItems	=	false

		let	m		=	MenuItemController()
		m.menuItem.enabled	=	true
		m.menuItem.title	=	title
		m.menuItem.submenu	=	sm
		m.onClick		=	nil
		return	m
	}
	public static func separatorMenuItemController() -> MenuItemController {
		return	MenuItemController(menuItem: NSMenuItem.separatorItem())
	}
}


@objc
private class _MenuItemAgent: NSObject {
	weak var owner: MenuItemController?
	@objc
	func EDITOR_onClick(sender: NSMenuItem?) {
		assertAndReportFailure(owner !== nil)
		assertAndReportFailure(owner!.onClick != nil)
		owner?._onClick?()
	}
}







