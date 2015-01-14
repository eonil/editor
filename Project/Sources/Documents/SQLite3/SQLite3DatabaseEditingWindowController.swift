//
//  SQLite3DatabaseEditingWindowController.swift
//  Editor
//
//  Created by Hoon H. on 11/17/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilSQLite3
import Precompilation

class SQLite3DatabaseEditingWindowController : HygienicWindowController, NSWindowDelegate {
	
	private var	database:Database?
	
	var	hostingDocument:NSDocument?
	var	URLRepresentation:NSURL? {
		didSet {
			self.window!.representedURL	=	self.URLRepresentation!
			self.window!.title			=	NSFileManager.defaultManager().displayNameAtPath(self.URLRepresentation!.path!)
			
			database	=	Database(location: Connection.Location.PersistentFile(path: URLRepresentation!.path!), editable: true)
		}
	}
	
	override func windowDidLoad() {
		super.windowDidLoad()
		self.window!.delegate	=	self
		
		self.contentViewController	=	SplitViewController()
	}
	

	func windowWillClose(notification: NSNotification) {
		hostingDocument!.close()
	}
}



private class SplitViewController : NSSplitViewController {
	let	databaseObjectTreeViewController	=	SQLite3ObjectTreeViewController()
	let	tableRowListingViewController		=	SQLite3TableRowListingViewController()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let	treeScroll	=	ScrollViewController()
		let	tableScroll	=	ScrollViewController()

		treeScroll.documentViewController	=	databaseObjectTreeViewController
		tableScroll.documentViewController	=	tableRowListingViewController

		self.splitView.vertical	=	true
		self.addChildViewControllerAsASplitViewItem(treeScroll)
		self.addChildViewControllerAsASplitViewItem(tableScroll)

		//	The priority constant doesn't work in Xcode 6.1. I am not sure that is a bug or feature.
		self.view.layoutConstraints	=	[
			treeScroll..width >= 100,
			tableScroll..width >= 100,
			
			treeScroll..width >= 400 ~~ 3,
			tableScroll..width >= 200 ~~ 2,
		]
	}
}



class SQLite3ObjectTreeViewController : EmptyOutlineViewController {
	
	var	namesOfTables	=	[] as [Box<String>]
	
	var	databaseRepresentation:Database? {
		didSet {
			self.outlineView.reloadData()
			databaseRepresentation?.schema.namesOfAllTables()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.outlineView.selectionHighlightStyle	=	NSTableViewSelectionHighlightStyle.SourceList
		self.outlineView.addTableColumn	<<<	NSTableColumn()
		self.outlineView.headerView		=	nil
	}
	
	func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		return	namesOfTables.count
	}
	func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		return	false
	}
	func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
		let	tname	=	item as Box<String>
		return	tname.value
	}
}


private class SQLite3TableRowListingViewController : TableViewController {
	
	var	connectionRepresentation:Connection? {
		didSet {
			
		}
	}
	
	private override func viewDidLoad() {
		super.viewDidLoad()
	}
}





