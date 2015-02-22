//
//  WorkspaceNavigationContextMenuController.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/22.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorUIComponents



final class WorkspaceNavigationContextMenuController: MenuController {
	let	showInFinder			=	NSMenuItem(title: "Show in Finder")
	let	showInTerminal			=	NSMenuItem(title: "Show in Terminal")
	let	newFile					=	NSMenuItem(title: "New File...")
	let	newFolder				=	NSMenuItem(title: "New Folder")
	let	newFolderWithSelection	=	NSMenuItem(title: "New Folder with Selection")
	let	delete					=	NSMenuItem(title: "Delete")
	let	addAllUnregistredFiles	=	NSMenuItem(title: "Add All Unregistered Files")
	let	removeAllMissingFiles	=	NSMenuItem(title: "Remove All Missing Files")
	let	note					=	NSMenuItem(title: "Note...")
	
	init() {
		let	m	=	NSMenu()
		m.autoenablesItems	=	false
		
		m.addItem(showInFinder)
		m.addItem(showInTerminal)
		m.addItem(NSMenuItem.separatorItem())
		m.addItem(newFile)
		m.addItem(newFolder)
		m.addItem(newFolderWithSelection)
		m.addItem(NSMenuItem.separatorItem())
		m.addItem(delete)
		m.addItem(NSMenuItem.separatorItem())
		m.addItem(addAllUnregistredFiles)
		m.addItem(removeAllMissingFiles)
		m.addItem(NSMenuItem.separatorItem())
		m.addItem(note)
		
		super.init(m)
	}
}

private extension NSMenuItem {
	convenience init(title:String) {
		self.init()
		self.title	=	title
	}
}