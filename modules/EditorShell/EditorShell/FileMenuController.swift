//
//  FileMenuController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/20.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel


class FileMenuController: SessionProtocol {

	weak var model: ApplicationModel?

	///

	init() {
		menu	=
			_topLevelMenu("File", items: [
				newWorkspace,
				_menuItem("Open", submenu: open.menu),
				closeWorkspace,
				])

	}
	deinit {
	}

	///

	let	menu		:	TopLevelCommandMenu
	let	newWorkspace	=	_menuItem("New Workspace", shortcut: Command+"N")
	let	open		=	FileOpenMenuController()
	let	closeWorkspace	=	_menuItem("Close Workspace", shortcut: Command+"W")

	func run() {
		assert(model != nil)

		newWorkspace.clickHandler	=	{ [weak self] in
			Dialogue.runSavingWorkspace({ (u: NSURL?) -> () in
				if let u = u {
					self?.model!.createAndOpenWorkspaceAtURL(u)
				}
			})
		}
		closeWorkspace.clickHandler	=	{ [weak self] in
			self?._handleClosingCurrentWorkspace()
		}

		let	apply	=	{ [weak self] in
			assert(self != nil)
			self?._applyEnabledStates()
		}

		_applyEnabledStates()
		model!.currentWorkspace.registerDidSet(ObjectIdentifier(self), handler: apply)

		open.model	=	model!
		open.run()
	}
	func halt() {
		assert(model != nil)

		open.halt()
		open.model	=	nil

		model!.currentWorkspace.deregisterDidSet(ObjectIdentifier(self))
		_applyEnabledStates()

		closeWorkspace.clickHandler	=	nil
		newWorkspace.clickHandler	=	nil
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







