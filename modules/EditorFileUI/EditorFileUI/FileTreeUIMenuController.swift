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

		FileNodeModel.Event.Notification.register		(self, FileTreeUIMenuController._process)
		UIState.ForFileTreeModel.Notification.register		(self, FileTreeUIMenuController._process)
		_Event.Notification.register				(self, FileTreeUIMenuController._process)
	}
	deinit {
		_Event.Notification.deregister				(self)
		UIState.ForFileTreeModel.Notification.deregister	(self)
		FileNodeModel.Event.Notification.deregister		(self)
	}







	///

	private func _process(n: FileNodeModel.Event.Notification) {
		guard n.sender.tree === model! else {
			return
		}


	}
	private func _process(n: UIState.ForFileTreeModel.Notification) {
		guard n.sender === model! else {
			return
		}

		UIState.ForFileTreeModel.get(model!) {
			delete.enabled		=	$0.fileSustainingSelection.count > 0
			showInFinder.enabled	=	$0.fileSustainingSelection.count > 0
		}
	}
	private func _process(n: _Event.Notification) {
		switch ObjectIdentifier(n.sender) {
		case ObjectIdentifier(newFile): do {
			}

		case ObjectIdentifier(newFolder): do {
			}

		case ObjectIdentifier(delete): do {
			}

		case ObjectIdentifier(showInFinder): do {
			}

		default: do {
			fatalError()
			}
		}
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
		Notification(m,_Event.Click).broadcast()
	}
	return	m
}
