//
//  WorkspaceDocument.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

///	A document to edit Eonil Editor Workspace. (`.eewsN` file, `N` is single integer version number)
///	The root controller of a workspace.
class WorkspaceDocument : NSDocument {
	let	mainWindowController		=	WorkspaceMainWindowController()
	
	override func makeWindowControllers() {
		super.makeWindowControllers()
		self.addWindowController(mainWindowController)
	}
	
//	override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
//		let	s1	=	projectWindowController.codeEditingViewController.codeTextViewController.codeTextView.string!
//		let	d1	=	s1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//		return	d1
//	}
	
	override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		return	true
	}
	
	
	
	override func saveDocument(sender: AnyObject?) {
		//	Do not route save messages to current document.
		//	Saving of a project will be done at somewhere else, and this makes annoying alerts.
		///	This prevents the alerts.
		//		super.saveDocument(sender)
	}
	
	
	
	
	
	override class func autosavesInPlace() -> Bool {
		return false
	}
}




