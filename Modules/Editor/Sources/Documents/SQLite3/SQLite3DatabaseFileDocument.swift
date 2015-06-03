//
//  SQLite3DatabaseFileDocument.swift
//  Editor
//
//  Created by Hoon H. on 11/17/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit

///	This document is just a gateway to `SQLiteDatabaseEditingWindowController` class.
///	This activates the window controller, and does nothing else. Actuall data I/O will
///	be done in the window controller instead of document.
///	Users are not allowed to use "Save..." or "Undo..." menu due to immediate nature 
///	of SQLite3.
class SQLite3DatabaseFileDocument : NSDocument {
	let	editingWindowController	=	SQLite3DatabaseEditingWindowController()

	override func makeWindowControllers() {
		super.makeWindowControllers()
		editingWindowController.hostingDocument	=	self
//		self.addWindowController(editingWindowController)
	}
	
	override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
		//	Do not store using this.
		return	nil
	}
	
	override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		editingWindowController.window!.orderFront(self)
		editingWindowController.window!.makeKeyWindow()
		editingWindowController.URLRepresentation	=	self.fileURL!
		
		return	true
	}
	
	
	
	
	
	
	
	
	
	override class func autosavesInPlace() -> Bool {
		return false
	}
	
	
	
}