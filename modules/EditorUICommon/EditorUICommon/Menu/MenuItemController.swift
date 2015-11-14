//
//  MenuItemController.swift
//  EditorUICommon
//
//  Created by Hoon H. on 2015/11/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit


/// Wraps `NSMenuItem` ti provide better dynamic management.
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
		_cocoaMenuItem.action	=	Selector("onClick:")
	}
	deinit {
		_cocoaMenuItem.target	=	nil
		_cocoaMenuItem.action	=	nil
		_cocoaMenuAgent.owner	=	nil
	}





	///

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
	public var menuItem: NSMenuItem {
		get {
			return	_cocoaMenuItem
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


@objc
private class _MenuItemAgent: NSObject {
	weak var owner: MenuItemController?
	@objc
	func onClick(sender: NSMenuItem) {
		owner!._onClick?()
	}
}
