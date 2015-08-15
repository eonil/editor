//
//  MenuController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorUICommon
import EditorModel

public class MainMenuController: SessionProtocol {

	public weak var model: Model? {
		willSet {
			assert(_isRunning == false)
		}
		didSet {
			_file.model	=	model
			_product.model	=	model
			_debug.model	=	model
		}
	}

	///

	public init() {
		_topItems	=	[
			_file.menu,
			_product.menu,
			_debug.menu,
		]
	}

	///

	public var topLevelMenus: [NSMenu] {
		get {
			return	_topItems
		}
	}
	public func run() {
		assert(model != nil)
		for s in _allSessionObjects() {
			s.run()
		}
	}
	public func halt() {
		assert(model != nil)
		for s in _allSessionObjects() {
			s.halt()
		}
	}

	///

	private let	_topItems	:	[TopLevelCommandMenu]

	private let	_file		=	FileMenuController()
	private let	_product	=	ProductMenuController()
	private let	_debug		=	DebugMenuController()

	private var	_isRunning	=	false

	private func _allSessionObjects() -> [SessionProtocol] {
		return	[
			_file,
			_product,
			_debug,
		]
	}
}





class FileMenuController: SessionProtocol {

	weak var model: Model?

	///

	init() {
		menu	=
			_topLevelMenu("File", items: [
				newWorkspace,
				openWorkspace,
				closeWorkspace,
				])

	}
	deinit {
	}

	///

	let	menu		:	TopLevelCommandMenu
	let	newWorkspace	=	_menuItem("New Workspace")
	let	openWorkspace	=	_menuItem("Open Workspace",	.Workspace(.Open))
	let	closeWorkspace	=	_menuItem("Close Workspace",	.Workspace(.Close))

	func run() {
		newWorkspace.clickHandler	=	{ [weak self] in
			Dialogue.runOpeningWorkspace({ (u: NSURL?) -> () in
				if let u = u {
					self?.model!.openWorkspaceAtURL(u)
				}
			})
		}

		let	apply	=	{ [weak self] in
			assert(self != nil)
			self?._applyEnabledStates()
		}
		model!.currentWorkspace.registerDidSet(ObjectIdentifier(self), handler: apply)
	}
	func halt() {
		model!.currentWorkspace.deregisterDidSet(ObjectIdentifier(self))

		newWorkspace.clickHandler	=	nil
	}

	///

	private func _applyEnabledStates() {
		closeWorkspace.enabled		=	model!.currentWorkspace.value != nil
	}
}

class ProductMenuController: SessionProtocol {

	weak var model: Model?

	///

	init() {
		menu	=	_topLevelMenu("Product", items: [
			])
	}

	///

	let	menu		:	TopLevelCommandMenu

	func run() {

	}
	func halt() {

	}
}




class DebugMenuController: SessionProtocol {

	weak var model: Model?

	///

	init() {
		menu	=
			_topLevelMenu("Debug", items: [
				pause,
				resume,
				stop,
				_menuSeparatorItem(),
				stepInto,
				stepOut,
				stepOver,
				])

	}

	///

	let	menu		:	TopLevelCommandMenu
	let	pause		=	_menuItem("Pause", 	.Debugging(.Pause))
	let	resume		=	_menuItem("Resume",	.Debugging(.Resume))
	let	stop		=	_menuItem("Halt",	.Debugging(.Halt))
	let	stepInto	=	_menuItem("Step Into",	.Debugging(.StepInto))
	let	stepOut		=	_menuItem("Step Out",	.Debugging(.StepOut))
	let	stepOver	=	_menuItem("Step Over",	.Debugging(.StepOver))

	func run() {

	}
	func halt() {

	}
}


































final class TopLevelCommandMenu: CommandMenu {
	weak var commandQueue: CommandQueue?
	override func routeCommand(command: ModelCommand) {
		assert(commandQueue != nil)
		commandQueue?.queueCommand(command)
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









struct Shortcut {

}


private func _topLevelMenu(title: String, items: [NSMenuItem]) -> TopLevelCommandMenu {
	let	m		=	TopLevelCommandMenu(title: title)
	m.autoenablesItems	=	false
	for item in items {
		m.addItem(item)
	}
	return	m
}
private func _menuItem(label: String, submenu: NSMenu) -> CommandMenuItem {
	let	m		=	CommandMenuItem(title: label, action: nil, keyEquivalent: "")
	m.submenu		=	submenu
	return	m
}
private func _menuItem(label: String, _ command: ModelCommand) -> CommandMenuItem {
	let	m		=	CommandMenuItem(title: label, action: nil, keyEquivalent: "")
	m.command		=	command
	return	m
}
private func _menuItem(label: String) -> SelfHandlingMenuItem {
	let	m		=	SelfHandlingMenuItem(title: label, action: nil, keyEquivalent: "")
	return	m
}

private func _menuSeparatorItem() -> NSMenuItem {
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





