//
//  MainMenuController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/07.
//  Copyright © 2015 Eonil. All rights reserved.
//

import AppKit
import EditorModel









enum MenuCommand {
	case NewSubfileInCurrentFolderItemInCurrentWorkspace
	case NewSubfolderInCurrentFolderItemInCurrentWorkspace
	case OpenWorkspaceByBrowsingIt
	case CloseCurrentWorkspace

	case ProductRun
	case ProductBuild
	case ProductClean
	case ProductStop

	case DebugPause
	case DebugResume
	case DebugHalt
	case DebugStepInto
	case DebugStepOut
	case DebugStepOver
}






class MenuController2 {
	let	file			=	_instantiateGroupMenuItem("File")
	let	fileNew			=	_instantiateGroupMenuItem("New")
	let	fileNewFile		=	_instantiateCommandBroadcastingMenuItem("File...", command: .NewSubfileInCurrentFolderItemInCurrentWorkspace)
	let	fileNewFolder		=	_instantiateCommandBroadcastingMenuItem("Folder...", command: .NewSubfolderInCurrentFolderItemInCurrentWorkspace)
	let	fileOpen		=	_instantiateGroupMenuItem("Open")
	let	fileOpenWorkspae	=	_instantiateCommandBroadcastingMenuItem("Workspace...", command: .OpenWorkspaceByBrowsingIt)
	let	fileCloseWorkspace	=	_instantiateCommandBroadcastingMenuItem("Close Workspace", command: .CloseCurrentWorkspace)

	let	product			=	_instantiateGroupMenuItem("Product")
	let	productRun		=	_instantiateCommandBroadcastingMenuItem("Run", command: .ProductRun)
	let	productBuild		=	_instantiateCommandBroadcastingMenuItem("Build", command: .ProductBuild)
	let	productClean		=	_instantiateCommandBroadcastingMenuItem("Clean", command: .ProductClean)
	let	productStop		=	_instantiateCommandBroadcastingMenuItem("Stop", command: .ProductStop)

	let	debug			=	_instantiateGroupMenuItem("Debug")
	let	debugPause		=	_instantiateCommandBroadcastingMenuItem("Pause", command: .DebugPause)
	let	debugResume		=	_instantiateCommandBroadcastingMenuItem("Resume", command: .DebugResume)
	let	debugHalt		=	_instantiateCommandBroadcastingMenuItem("Halt", command: .DebugHalt)

	let	debugStepInto		=	_instantiateCommandBroadcastingMenuItem("Step Into", command: .DebugStepInto)
	let	debugStepOut		=	_instantiateCommandBroadcastingMenuItem("Step Out", command: .DebugStepOut)
	let	debugStepOver		=	_instantiateCommandBroadcastingMenuItem("Step Over", command: .DebugStepOver)

	init() {
		file.addSubmenuItems([
			fileNew,
			fileOpen,
			fileCloseWorkspace,
			])
		fileNew.addSubmenuItems([
			fileNewFile,
			fileNewFolder,
			])
		fileOpen.addSubmenuItems([
			fileOpenWorkspae,
			])

		product.addSubmenuItems([
			productRun,
			productBuild,
			productClean,
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
			])

		_setMainMenu()
	}

}
extension MenuController2 {
	private func _setMainMenu() {
		assert(NSApplication.sharedApplication().mainMenu == nil, "Main menu already been set.")

		let	mainMenu		=	NSMenu()									//	`title` really doesn't matter.
		let	mainAppMenuItem		=	NSMenuItem(title: "Application", action: nil, keyEquivalent: "")		//	`title` really doesn't matter.
//		let	mainFileMenuItem	=	NSMenuItem(title: "File", action: nil, keyEquivalent: "")
		mainMenu.addItem(mainAppMenuItem)
//		mainMenu.addItem(mainFileMenuItem)

		let	appMenu			=	NSMenu()									//	`title` really doesn't matter.
		mainAppMenuItem.submenu		=	appMenu

		let	appServicesMenu		=	NSMenu()
		NSApp.servicesMenu		=	appServicesMenu
		appMenu.addItemWithTitle("About Me", action: nil, keyEquivalent: "")
		appMenu.addItem(NSMenuItem.separatorItem())
		appMenu.addItemWithTitle("Preferences...", action: nil, keyEquivalent: ",")
		appMenu.addItem(NSMenuItem.separatorItem())
		appMenu.addItemWithTitle("Hide Me", action: "hide:", keyEquivalent: "h")
		appMenu.addItem({ ()->NSMenuItem in
			let m	=	NSMenuItem(title: "Hide Others", action: "hideOtherApplications:", keyEquivalent: "h")
			m.keyEquivalentModifierMask	=	Int(NSEventModifierFlags([.CommandKeyMask, .AlternateKeyMask]).rawValue)
			return	m
			}())
		appMenu.addItemWithTitle("Show All", action: "unhideAllApplications:", keyEquivalent: "")

		appMenu.addItem(NSMenuItem.separatorItem())
		appMenu.addItemWithTitle("Services", action: nil, keyEquivalent: "")!.submenu	=	appServicesMenu
		appMenu.addItem(NSMenuItem.separatorItem())
		appMenu.addItemWithTitle("Quit Me", action: "terminate:", keyEquivalent: "q")
//
//		let	fileMenu		=	NSMenu(title: "File")
//		mainFileMenuItem.submenu	=	fileMenu
//		fileMenu.addItemWithTitle("New...", action: "newDocument:", keyEquivalent: "n")

		mainMenu.addItem(file._cocoaMenuItem)
		mainMenu.addItem(product._cocoaMenuItem)
		mainMenu.addItem(debug._cocoaMenuItem)

		NSApplication.sharedApplication().mainMenu		=	mainMenu
	}
}

































private func _instantiateGroupMenuItem(title: String) -> MenuItemController {
	let	m		=	MenuItemController()
	m._cocoaMenuItem.title	=	title
	m._onClick		=	{}
	return	m
}

private func _instantiateCommandBroadcastingMenuItem(title: String, command: MenuCommand) -> MenuItemController {
	return	_instantiateCommandBroadcastingMenuItem(title, shortcut: nil, command: command)
}
private func _instantiateCommandBroadcastingMenuItem(title: String, shortcut: MenuShortcutKeyCombination?, command: MenuCommand) -> MenuItemController {
	let	m		=	MenuItemController()
	m._cocoaMenuItem.title				=	title
	if let shortcut = shortcut {
		m._cocoaMenuItem.keyEquivalent			=	shortcut.plainTextKeys
		m._cocoaMenuItem.keyEquivalentModifierMask	=	Int(bitPattern: shortcut.modifierMask)
	}
	m._onClick		=	{ [weak m] in
		guard m != nil else {
			return
		}
		Notification(m, command).broadcast()
	}
	return	m
}
private func _instantiateSeparatorMenuItem() -> MenuItemController {
	let	m		=	MenuItemController(NSMenuItem.separatorItem())
	return	m
}







































class MenuItemController {
	func addSubmenuItems(items: [MenuItemController]) {
		if _cocoaMenuItem.submenu == nil {
			_cocoaMenuItem.submenu	=	NSMenu()
		}
		for item in items {
			_cocoaMenuItem.submenu!.addItem(item._cocoaMenuItem)
		}
	}




	///

	private init(_ cocoaMenuItem: NSMenuItem = NSMenuItem()) {
		_cocoaMenuItem		=	cocoaMenuItem
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

	private var	_onClick	:	(() -> ())?
	private let	_cocoaMenuItem	:	NSMenuItem
	private let	_cocoaMenuAgent	=	_MenuItemAgent()
}


@objc
private class _MenuItemAgent: NSObject {
	weak var owner: MenuItemController?
	@objc
	func onClick(sender: NSMenuItem) {
		assert(owner!._onClick != nil)
		owner!._onClick!()
	}
}


















