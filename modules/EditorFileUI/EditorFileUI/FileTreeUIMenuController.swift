//
//  FileTreeUIMenuController.swift
//  EditorFileUI
//
//  Created by Hoon H. on 2015/11/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorModel
import EditorUICommon

class FileTreeUIMenuController {

	weak var model: FileTreeModel?

	var getClickedFileNode: (()->WorkspaceItemNode?)?




	///

	let	menu		=	NSMenu()

	let	newFile		=	_instantiateCommandMenuItemController("New File")
	let	newFolder	=	_instantiateCommandMenuItemController("New Folder")
	let	delete		=	_instantiateCommandMenuItemController("Delete")
	let	showInFinder	=	_instantiateCommandMenuItemController("Show in Finder")






	///

	init() {
		menu.autoenablesItems	=	false

		let	items	=	[
			newFile,
			newFolder,
			MenuItemController.separatorMenuItemController(),
			delete,
			MenuItemController.separatorMenuItemController(),
			showInFinder,
		]

		for m in items {
			menu.addItem(m.menuItem)
		}

		_agent.owner	=	self
		menu.delegate	=	_agent

		FileTreeModel.Event.Notification.register		(self, FileTreeUIMenuController._process)
		UIState.ForFileTreeModel.Notification.register		(self, FileTreeUIMenuController._process)
		_Event.Notification.register				(self, FileTreeUIMenuController._process)
	}
	deinit {
		_Event.Notification.deregister				(self)
		UIState.ForFileTreeModel.Notification.deregister	(self)
		FileTreeModel.Event.Notification.deregister		(self)
	}












	///

	private let _agent	=	_MenuAgent()

	private func _process(n: FileTreeModel.Event.Notification) {
		guard n.sender.tree === model! else {
			return
		}
	}
	private func _process(n: UIState.ForFileTreeModel.Notification) {
		guard n.sender === model! else {
			return
		}
		_updateMenu()
	}

	private func _updateMenu() {
		let	ns		=	_getAppropriateOperationTargetFileNodes()
		newFile.enabled		=	ns.count == 1 && ns[0].isGroup
		newFolder.enabled	=	ns.count == 1 && ns[0].isGroup
		delete.enabled		=	ns.count > 0
		showInFinder.enabled	=	ns.count > 0
	}








	private func _process(n: _Event.Notification) {
		let	ns	=	_getAppropriateOperationTargetFileNodes()

		switch ObjectIdentifier(n.sender) {
		case ObjectIdentifier(newFile): do {
			assert(ns.count == 1)
			let	n	=	ns[0]
			try! model!.newFileInNode(n, atIndex: n.subnodes.count)
			}

		case ObjectIdentifier(newFolder): do {
			assert(ns.count == 1)
			let	n	=	ns[0]
			try! model!.newFolderInNode(n, atIndex: n.subnodes.count)
			}

		case ObjectIdentifier(delete): do {
			try! model!.deleteNodes(ns)
			UIState.ForFileTreeModel.set(model!) {
				$0.sustainingFileSelection	=	[]
				()
			}
			}

		case ObjectIdentifier(showInFinder): do {
			func toURL(n: WorkspaceItemNode) -> NSURL {
				return	n.resolvePath().absoluteFileURL(`for`: model!.workspace)
			}
			NSWorkspace.sharedWorkspace().activateFileViewerSelectingURLs(ns.map(toURL))
			}

		default: do {
			fatalError()
			}
		}
	}














	private func _getAppropriateOperationTargetFileNodes() -> [WorkspaceItemNode] {
		let	momentaryFileGrabbing	=	getClickedFileNode?()
		let	sustainingFileSelection	=	{
			var fs	=	[WorkspaceItemNode]()
			UIState.ForFileTreeModel.get(self.model!) {
				fs	=	$0.sustainingFileSelection
			}
			return	fs
			}() as [WorkspaceItemNode]
		let	isSustainingSelectionContainsMomentaryGrabbing	=	{
			guard let temporalFileGrabbing = momentaryFileGrabbing else {
				return	false
			}
			return	sustainingFileSelection.containsValueByReferentialIdentity(temporalFileGrabbing)
			}() as Bool



		if isSustainingSelectionContainsMomentaryGrabbing {
			return	sustainingFileSelection
		}
		else {
			if let momentaryFileGrabbing = momentaryFileGrabbing {
				return	[momentaryFileGrabbing]
			}
			else {
				return	sustainingFileSelection
			}
		}
	}

}














private class _MenuAgent: NSObject, NSMenuDelegate {
	weak var owner: FileTreeUIMenuController?
	@objc
	private func menuNeedsUpdate(menu: NSMenu) {
		owner!._updateMenu()
	}
	@objc
	private func menuWillOpen(menu: NSMenu) {
	}
	@objc
	private func menuDidClose(menu: NSMenu) {
	}
}
















private enum _Event {
	typealias	Notification	=	EditorModel.Notification<MenuItemController, _Event>
	case Click
}

private func _instantiateCommandMenuItemController(title: String) -> MenuItemController {
	let	m		=	MenuItemController()
	m.menuItem.title	=	title
	m.enabled		=	false
	m.onClick		=	{
		_Event.Notification(m, .Click).broadcast()
	}
	return	m
}



















