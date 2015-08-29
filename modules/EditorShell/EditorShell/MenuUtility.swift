//
//  MenuUtility.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorModel



final class TopLevelCommandMenu: CommandMenu {
//	weak var commandQueue: CommandQueue?
	override func routeCommand(command: ModelCommand) {
//		assert(commandQueue != nil)
//		commandQueue?.queueCommand(command)
		fatalErrorBecauseUnimplementedYet()
	}
}

class CommandMenu: NSMenu {
	func routeCommand(command: ModelCommand) {
		assert(supermenu != nil)
		assert(supermenu is CommandMenu)
		if let supermenu = supermenu as? CommandMenu {
			supermenu.routeCommand(command)
		}
	}
}

class CommandMenuItem: NSMenuItem {

	var command: ModelCommand?

	override init() {
		super.init()
		_setup()
	}
	override init(title aString: String, action aSelector: Selector, keyEquivalent charCode: String) {
		super.init(title: aString, action: aSelector, keyEquivalent: charCode)
		_setup()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	@objc
	func EDITOR_onEvent(_: AnyObject?) {
		assert(command != nil)
		assert(menu != nil)
		assert(menu is CommandMenu)
		if let menu = menu as? CommandMenu, let command = command {
			menu.routeCommand(command)
		}
	}

	private func _setup() {
		self.target	=	self
		self.action	=	"EDITOR_onEvent:"
	}
}






func _topLevelMenu(title: String, items: [NSMenuItem]) -> TopLevelCommandMenu {
	let	m		=	TopLevelCommandMenu(title: title)
	m.autoenablesItems	=	false
	for item in items {
		m.addItem(item)
	}
	return	m
}
func _menu(title: String, items: [NSMenuItem]) -> NSMenu {
	let	m		=	NSMenu(title: title)
	m.autoenablesItems	=	false
	for item in items {
		m.addItem(item)
	}
	return	m
}


func _menuItem(label: String, submenu: NSMenu) -> CommandMenuItem {
	let	m		=	CommandMenuItem(title: label, action: nil, keyEquivalent: "")
	m.submenu		=	submenu
	m.enabled		=	false
	return	m
}
func _menuItem(label: String, _ command: ModelCommand) -> CommandMenuItem {
	let	m		=	CommandMenuItem(title: label, action: nil, keyEquivalent: "")
	m.command		=	command
	m.enabled		=	false
	return	m
}
func _menuItem(label: String, shortcut: MenuShortcutKeyCombination = MenuShortcutKeyCombination.None) -> SelfHandlingMenuItem {
	let	m		=	SelfHandlingMenuItem(title: label, shortcut: shortcut, availability: true)
	m.enabled		=	false
	return	m
}
func _menuItem(label: String, shortcutWithLegacyUTF16CodeUnit utf16CodeUnit: Int) -> SelfHandlingMenuItem {
	return	_menuItem(label, shortcut: MenuShortcutKeyCombination(legacyUTF16CodeUnit: unichar(utf16CodeUnit)))
}


func _menuSeparatorItem() -> NSMenuItem {
	return	NSMenuItem.separatorItem()
}












@objc
final class SelfHandlingMenuItem: NSMenuItem {
	var clickHandler: (()->())? {
		willSet {
			if clickHandler != nil {
				target	=	nil
				action	=	nil
			}
		}
		didSet {
			if clickHandler != nil {
				target	=	self
				action	=	"EDITOR_onEvent:"
			}
		}
	}
	@objc
	func EDITOR_onEvent(_: AnyObject?) {
		clickHandler?()
	}
}