//
//  FileMenuController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/20.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorModel


class FileMenuController: SessionProtocol {

	weak var model: ApplicationModel?

	///

	init() {
		menu	=
			_topLevelMenu("File", items: [
				_menuItem("New", submenu: new.menu),
				_menuItem("Open", submenu: open.menu),
				closeWorkspace,
				])

	}
	deinit {
	}

	///

	let	menu		:	TopLevelCommandMenu
	let	new		=	FileNewMenuController()
	let	open		=	FileOpenMenuController()
	let	closeWorkspace	=	_menuItem("Close Workspace", shortcut: Command+"W")

	func run() {
		assert(model != nil)

		closeWorkspace.clickHandler	=	{ [weak self] in
			self?._handleClosingCurrentWorkspace()
		}

		let	apply	=	{ [weak self] in
			assert(self != nil)
			self?._applyEnabledStates()
		}

		_applyEnabledStates()
		model!.currentWorkspace.registerDidSet(ObjectIdentifier(self), handler: apply)

		new.model	=	model!
		new.run()

		open.model	=	model!
		open.run()
	}
	func halt() {
		assert(model != nil)

		open.halt()
		open.model	=	nil

		new.halt()
		new.model	=	nil

		model!.currentWorkspace.deregisterDidSet(ObjectIdentifier(self))
		_applyEnabledStates()

		closeWorkspace.clickHandler	=	nil
	}

	///

	private func _applyEnabledStates() {
		assert(model != nil)
		closeWorkspace.enabled		=	model!.currentWorkspace.value != nil
	}
	private func _handleClosingCurrentWorkspace() {
		assert(model != nil)
		assert(model!.currentWorkspace.value != nil)
		if let curWS = model!.currentWorkspace.value {
			assert(model!.currentWorkspace.value === curWS)
			assert(model!.workspaces.contains(curWS) == true)
//			model!.deselectCurrentWorkspace()
//			assert(model!.currentWorkspace.value !== curWS)
//			assert(model!.workspaces.contains(curWS) == true)
			model!.closeWorkspace(curWS)
			assert(model!.workspaces.contains(curWS) == false)
		}
		else {
			fatalError()
		}
	}
}




class FileNewMenuController: SessionProtocol {
	weak var model: ApplicationModel?

	let	menu		:	NSMenu
	let	workspace	=	_menuItem("Workspace...", shortcut: Command+Control+"N")
	let	file		=	_menuItem("File", shortcut: Command+"N")
	let	folder		=	_menuItem("Folder", shortcut: Command+Alternate+"N")

	init() {
		menu		=	_menu("New...", items: [
			workspace,
			file,
			folder,
			])
	}
	func run() {
		workspace.clickHandler	=	{ [weak self] in self!._clickWorkspace() }
		file.clickHandler	=	{ [weak self] in self!._clickFile() }
		folder.clickHandler	=	{ [weak self] in self!._clickFolder() }

		_reapplyEnability()
		model!.defaultWorkspace.registerDidSet(ObjectIdentifier(self)) { [weak self] in
			self?._reapplyEnability()
		}
	}
	func halt() {
		model!.defaultWorkspace.deregisterDidSet(ObjectIdentifier(self))
		_reapplyEnability()

		folder.clickHandler	=	nil
		file.clickHandler	=	nil
		workspace.clickHandler	=	nil
	}

	///

	private func _reapplyEnability() {
		let	hasSelectedFile	=	model!.defaultWorkspace.value != nil && model!.defaultWorkspace.value!.location.value != nil // && model!.defaultWorkspace.value!.file.selection.
		workspace.enabled	=	true
		file.enabled		=	hasSelectedFile
		folder.enabled		=	hasSelectedFile
	}

	private func _clickWorkspace() {
		assert(model!.defaultWorkspace.value != nil)
		Dialogue.runSavingWorkspace({ [weak self] (u: NSURL?) -> () in
			if let u = u {
				self?.model!.createAndOpenWorkspaceAtURL(u)
			}
		})
	}
	private func _clickFile() {
		assert(model!.defaultWorkspace.value != nil)
		if let ws = model!.defaultWorkspace.value {
			markUnimplemented()
			ws.file.runCreatingFileAtPath(WorkspaceItemPath(parts: ["ttt1"]))
			ws.file.runCreatingFileAtPath(WorkspaceItemPath(parts: ["ttt1", "ttt2"]))
		}
	}
	private func _clickFolder() {
		assert(model!.defaultWorkspace.value != nil)
		if let ws = model!.defaultWorkspace.value {
			ws.file.runCreatingFolderAtPath(WorkspaceItemPath(parts: ["src", "testfolder1"]))
		}
	}
}
class FileOpenMenuController: SessionProtocol {
	weak var model: ApplicationModel?

	let	menu		=	_menu("Open...", items: [])
	let	workspace	=	_menuItem("Workspace...", shortcut: Command+"O")
	let	clearRecent	=	_menuItem("Clear Recent Workspaces")

	init() {

	}
	func run() {
		assert(model != nil)

		workspace.clickHandler	=	{ [weak self] in
			Dialogue.runOpeningWorkspace({ (u: NSURL?) -> () in
				if let u = u {
					self?.model!.openWorkspaceAtURL(u)
				}
			})
		}
		clearRecent.clickHandler	=	{ [weak self] in
			NSDocumentController.sharedDocumentController().clearRecentDocuments(self)
		}

		_menuAgent.owner	=	self
		menu.delegate		=	_menuAgent
	}
	func halt() {
		menu.delegate		=	nil
		_menuAgent.owner	=	nil

		clearRecent.clickHandler	=	nil
		workspace.clickHandler	=	nil
	}

	///

	private let	_menuAgent	=	_FileOpenMenuAgent()

	private func _refillRecentMenuItems() {
		func _makeRecentMenuItem(u: NSURL) -> NSMenuItem {
			let	m	=	_menuItem(u.lastPathComponent!)
			m.clickHandler	=	{ [weak self] in
				self?.model!.openWorkspaceAtURL(u)
			}
			return	m
		}
		let	ms	=	NSDocumentController.sharedDocumentController().recentDocumentURLs.map(_makeRecentMenuItem)
		menu.removeAllItems()
		menu.addItem(workspace)
		menu.addItem(_menuSeparatorItem())
		for m in ms {
			menu.addItem(m)
		}
		menu.addItem(_menuSeparatorItem())
		menu.addItem(clearRecent)
	}
}

@objc
private final class _FileOpenMenuAgent: NSObject, NSMenuDelegate {
	weak var owner: FileOpenMenuController?
	@objc
	private func menuWillOpen(menu: NSMenu) {
		owner!._refillRecentMenuItems()
	}
}







