//
//  MainMenuController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/07.
//  Copyright © 2015 Eonil. All rights reserved.
//

import AppKit
import EditorModel









//enum MainMenuCommand {
//	case FileNewWorkspace
//	case FileNewSubfileInCurrentFolderItemInCurrentWorkspace
//	case FileNewSubfolderInCurrentFolderItemInCurrentWorkspace
//	case FileOpenWorkspaceByBrowsingIt
//	case FileOpenClearRecentWorkspaces
//	case FileCloseCurrentWorkspace
//
//	case ProductRun
//	case ProductBuild
//	case ProductClean
//	case ProductStop
//
//	case DebugPause
//	case DebugResume
//	case DebugHalt
//	case DebugStepInto
//	case DebugStepOut
//	case DebugStepOver
//}
//enum MainMenuCategory {
//	case PlainCommand
//	case RecentFileItem
//	case WindowItem
//}






class MainMenuController {
	weak var model: ApplicationModel?

	//	Keep: (menu item identifier length < 64).

	let	file				=	_instantiateGroupMenuItem("File")
	let	fileNew				=	_instantiateGroupMenuItem("New")
	let	fileNewWorkspace		=	_instantiateCommandMenuItem("Worksace...",		Command+Control+"N"		)
	let	fileNewFile			=	_instantiateCommandMenuItem("File...",			Command+"N"			)
	let	fileNewFolder			=	_instantiateCommandMenuItem("Folder...",		Command+Alternate+"N"		)
	let	fileOpen			=	_instantiateGroupMenuItem("Open")
	let	fileOpenWorkspace		=	_instantiateCommandMenuItem("Workspace...", 		Command+"O"			)
	let	fileOpenClearWorkspaceHistory	=	_instantiateCommandMenuItem("Clear Recent Workspaces",	nil	 		)
	let	fileCloseCurrentFile		=	_instantiateCommandMenuItem("Close File",		Command+Shift+"W"		)
	let	fileCloseCurrentWorkspace	=	_instantiateCommandMenuItem("Close Workspace",		Command+"W"			)

	let	view				=	_instantiateGroupMenuItem("View")
	let	viewEditor			=	_instantiateCommandMenuItem("Editor",			Command+"\n"			)
	let	viewNavigators			=	_instantiateGroupMenuItem("Navigators")
	let	viewShowProjectNavivator	=	_instantiateCommandMenuItem("Show File Navigator",	Command+"1"			)
	let	viewShowDebugNavivator		=	_instantiateCommandMenuItem("Show Debug Navigator",	Command+"2"			)
	let	viewHideNavigator		=	_instantiateCommandMenuItem("Hide Navigator", 		Command+"0"			)
	let	viewConsole			=	_instantiateCommandMenuItem("Logs", 			Command+Shift+"C"		)

	let	product				=	_instantiateGroupMenuItem("Product")
	let	productRun			=	_instantiateCommandMenuItem("Run",			Command+"R"			)
	let	productBuild			=	_instantiateCommandMenuItem("Build",			Command+"B"			)
	let	productClean			=	_instantiateCommandMenuItem("Clean",			Command+Shift+"K"			)
	let	productStop			=	_instantiateCommandMenuItem("Stop",			Command+"."			)

	let	debug				=	_instantiateGroupMenuItem("Debug")
	let	debugPause			=	_instantiateCommandMenuItem("Pause",			Command+Control+"Y"		)
	let	debugResume			=	_instantiateCommandMenuItem("Resume",			Command+Control+"Y"		)
	let	debugHalt			=	_instantiateCommandMenuItem("Halt",			nil				)

	let	debugStepInto			=	_instantiateCommandMenuItem("Step Into",		_legacyFunctionKeyShortcut(NSF6FunctionKey))
	let	debugStepOut			=	_instantiateCommandMenuItem("Step Out",			_legacyFunctionKeyShortcut(NSF7FunctionKey))
	let	debugStepOver			=	_instantiateCommandMenuItem("Step Over",		_legacyFunctionKeyShortcut(NSF8FunctionKey))

	let	debugClearConsole		=	_instantiateCommandMenuItem("Clear Console", 		Command+"K")

	init() {
		file.addSubmenuItems([
			fileNew,
			fileOpen,
			_instantiateSeparatorMenuItem(),
			fileCloseCurrentFile,
			fileCloseCurrentWorkspace,
			])
		fileNew.addSubmenuItems([
			fileNewWorkspace,
			fileNewFile,
			fileNewFolder,
			])
		fileOpen.addSubmenuItems([
			fileOpenWorkspace,
			fileOpenClearWorkspaceHistory,
			])

		view.addSubmenuItems([
			viewEditor,
			viewNavigators,
			viewConsole,
			_instantiateSeparatorMenuItem()		//	Cocoa will add `Enter Full Screen` menu item automatically after this items. Prepare a separator for it.
			])
		viewNavigators.addSubmenuItems([
			viewShowProjectNavivator,
			viewShowDebugNavivator,
			_instantiateSeparatorMenuItem(),
			viewHideNavigator,
			])

		product.addSubmenuItems([
			productRun,
			productBuild,
			productClean,
			_instantiateSeparatorMenuItem(),
			productStop,
			])

		debug.addSubmenuItems([
			debugPause,
			debugResume,
			debugHalt,
			_instantiateSeparatorMenuItem(),
			debugStepInto,
			debugStepOut,
			debugStepOver,
			_instantiateSeparatorMenuItem(),
			debugClearConsole,
			])

	}
	deinit {
		assert(isRunning == false)
	}


	var isRunning: Bool = false {
		willSet {
			if isRunning == true {
				_terminateCommandProcessing()
				_unsetMainMenu()
			}
		}
		didSet {
			if isRunning == true {
				_setMainMenu()
				_initiateCommandProcessing()
			}
		}
	}
}
extension MainMenuController {
	private func _unsetMainMenu() {
		assert(NSApplication.sharedApplication().mainMenu != nil, "Main menu is not yet set.")
		NSApplication.sharedApplication().mainMenu	=	nil
	}
	private func _setMainMenu() {
		assert(NSApplication.sharedApplication().mainMenu == nil, "Main menu already been set.")

		let	appName			=	NSBundle.mainBundle().infoDictionary![kCFBundleNameKey as String] as! String

		let	mainMenu		=	NSMenu()									//	`title` really doesn't matter.
		let	mainAppMenuItem		=	NSMenuItem(title: "Application", action: nil, keyEquivalent: "")		//	`title` really doesn't matter.
		mainMenu.addItem(mainAppMenuItem)

		let	appMenu			=	NSMenu()									//	`title` really doesn't matter.
		mainAppMenuItem.submenu		=	appMenu

		let	appServicesMenu		=	NSMenu()
		NSApp.servicesMenu		=	appServicesMenu
		appMenu.addItemWithTitle("About \(appName)", action: nil, keyEquivalent: "")
		appMenu.addItem(NSMenuItem.separatorItem())
		appMenu.addItemWithTitle("Preferences...", action: nil, keyEquivalent: ",")
		appMenu.addItem(NSMenuItem.separatorItem())
		appMenu.addItemWithTitle("Hide \(appName)", action: "hide:", keyEquivalent: "h")
		appMenu.addItem({ ()->NSMenuItem in
			let m	=	NSMenuItem(title: "Hide Others", action: "hideOtherApplications:", keyEquivalent: "h")
			m.keyEquivalentModifierMask	=	Int(NSEventModifierFlags([.CommandKeyMask, .AlternateKeyMask]).rawValue)
			return	m
			}())
		appMenu.addItemWithTitle("Show All", action: "unhideAllApplications:", keyEquivalent: "")

		appMenu.addItem(NSMenuItem.separatorItem())
		appMenu.addItemWithTitle("Services", action: nil, keyEquivalent: "")!.submenu	=	appServicesMenu
		appMenu.addItem(NSMenuItem.separatorItem())
		appMenu.addItemWithTitle("Quit \(appName)", action: "terminate:", keyEquivalent: "q")

		mainMenu.addItem(file._cocoaMenuItem)
		mainMenu.addItem(view._cocoaMenuItem)
		mainMenu.addItem(product._cocoaMenuItem)
		mainMenu.addItem(debug._cocoaMenuItem)

		NSApplication.sharedApplication().mainMenu		=	mainMenu
	}
}

extension MainMenuController {
	private func _initiateCommandProcessing() {
		assert(model != nil)
		Notification<MenuItemController,()>.register	(self, MainMenuController.process)
	}
	private func _terminateCommandProcessing() {
		assert(model != nil)
		Notification<MenuItemController,()>.deregister	(self)
	}
}





























private func _legacyFunctionKeyShortcut(utf16CodeUnit: Int) -> MenuShortcutKeyCombination {
	return	MenuShortcutKeyCombination(legacyUTF16CodeUnit: unichar(utf16CodeUnit))
}

private func _instantiateGroupMenuItem(title: String) -> MenuItemController {
	let	sm			=	NSMenu(title: title)
	sm.autoenablesItems		=	false

	let	m			=	MenuItemController()
	m._cocoaMenuItem.enabled	=	true
	m._cocoaMenuItem.title		=	title
	m._cocoaMenuItem.submenu	=	sm
	m._onClick			=	nil
	return	m
}
//private func _instantiateCommandMenuItem(title: String, command: MainMenuCommand) -> MenuItemController {
//	return	_instantiateCommandMenuItem(title, nil, command)
//}
private func _instantiateCommandMenuItem(title: String, _ shortcut: MenuShortcutKeyCombination?) -> MenuItemController {
	let	m			=	MenuItemController()
	m._cocoaMenuItem.title		=	title

	if let shortcut = shortcut {
		m._cocoaMenuItem.keyEquivalent			=	shortcut.plainTextKeys
		m._cocoaMenuItem.keyEquivalentModifierMask	=	Int(bitPattern: shortcut.modifierMask)
	}
	m._onClick = { [weak m] in
		guard let m = m else {
			return
		}
		Notification<MenuItemController,()>(m, ()).broadcast()
	}
	return	m
}
//private func _instantiateCommandMenuItem(title: String, _ shortcut: MenuShortcutKeyCombination?, _ command: MainMenuCommand) -> MenuItemController {
//	let	m			=	MenuItemController()
//	m._cocoaMenuItem.title		=	title
//
//	if let shortcut = shortcut {
//		m._cocoaMenuItem.keyEquivalent			=	shortcut.plainTextKeys
//		m._cocoaMenuItem.keyEquivalentModifierMask	=	Int(bitPattern: shortcut.modifierMask)
//	}
//
//	m._onClick = { [weak m] in
//		guard m != nil else {
//			return
//		}
//		Notification(m, command).broadcast()
//	}
//	return	m
//}

private func _instantiateSeparatorMenuItem() -> MenuItemController {
	let	m		=	MenuItemController(NSMenuItem.separatorItem())
	return	m
}







































class MenuItemController {
	func addSubmenuItems(items: [MenuItemController]) {
		guard _cocoaMenuItem.submenu != nil else {
			fatalError("Current menu item is not intended to be a group. Please review the code.")
		}
		for item in items {
			_cocoaMenuItem.submenu!.addItem(item._cocoaMenuItem)
		}
		_subcontrollers.appendContentsOf(items)
	}




	///

	private init(_ cocoaMenuItem: NSMenuItem = NSMenuItem()) {
		_cocoaMenuItem		=	cocoaMenuItem
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

	var enabled: Bool {
		get {
			return	_cocoaMenuItem.enabled
		}
		set {
			_cocoaMenuItem.enabled	=	newValue
		}
	}
	var onClick: (() -> ())? {
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
	var description: String {
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
	var debugDescription: String {
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















private let	Command		=	MenuShortcutKeyCombination.Command
private let	Control		=	MenuShortcutKeyCombination.Control
private let	Alternate	=	MenuShortcutKeyCombination.Alternate
private let	Shift		=	MenuShortcutKeyCombination.Shift












