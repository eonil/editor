//
//  ContextMenuController.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/22.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorUIComponents



final class ContextMenuController: MenuController {
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
		
		[
			showInFinder,
//			showInTerminal,
			NSMenuItem.separatorItem(),
			newFile,
			newFolder,
//			newFolderWithSelection,
			NSMenuItem.separatorItem(),
			delete,
//			NSMenuItem.separatorItem(),
//			addAllUnregistredFiles,
//			removeAllMissingFiles,
//			NSMenuItem.separatorItem(),
//			note,
		].map(m.addItem)
		
		super.init(m)
	}
}

private extension NSMenuItem {
	convenience init(title:String) {
		self.init()
		self.title	=	title
	}
}