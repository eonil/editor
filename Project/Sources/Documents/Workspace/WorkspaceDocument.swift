//
//  WorkspaceDocument.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import PrecompilationOfExternalToolSupport

///	A document to edit Eonil Editor Workspace. (`.eewsN` file, `N` is single integer version number)
///	The root controller of a workspace.
class WorkspaceDocument : NSDocument {
	let	mainWindowController		=	PlainFileFolderWindowController()
	
	override func makeWindowControllers() {
		super.makeWindowControllers()
		self.addWindowController(mainWindowController)
	}
	
	
	override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
		fatalError("Saving features all should be overridden to save current data file instead of workspace document. This method shouldn't be called.")
//		let	s1	=	mainWindowController.codeEditingViewController.codeTextViewController.codeTextView.string!
//		let	d1	=	s1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//		return	d1
	}
	
	
	override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		let	s1	=	NSString(data: data, encoding: NSUTF8StringEncoding)!
		mainWindowController.codeEditingViewController.codeTextViewController.codeTextView.string	=	s1
//		let	p2	=	self.fileURL!.path!
//		let	p3	=	p2.stringByDeletingLastPathComponent
//		projectWindowController.mainViewController.navigationViewController.fileTreeViewController.pathRepresentation	=	p3
		
		let	u2	=	self.fileURL!.URLByDeletingLastPathComponent
		mainWindowController.mainViewController.navigationViewController.fileTreeViewController.URLRepresentation	=	u2
		return	true
	}
	
	override class func autosavesInPlace() -> Bool {
		return false
	}
	
	
	private var rootURL:NSURL {
		get {
			return	mainWindowController.fileTreeViewController.URLRepresentation!		//	This cannot be `nil` if this document has been configured properly.
		}
	}
	
	private func runWorkspace() {
		CargoExecutionController.execute(rootURL)
	}
}





















///	MARK:
///	MARK:	Menu handling via First Responder chain

extension WorkspaceDocument {
	
	///	Overridden to save currently editing data file.
	@objc @IBAction
	override func saveDocument(AnyObject?) {
		//	Do not route save messages to current document.
		//	Saving of a project will be done at somewhere else, and this makes annoying alerts.
		//	This prevents the alerts.
		//		super.saveDocument(sender)
		
		mainWindowController.codeEditingViewController.trySavingInPlace()
	}
	
	@objc @IBAction
	override func saveDocumentAs(sender: AnyObject?) {
		fatalError("Not implemented yet.")
	}
	
	///	Closes data file if one is exists.
	///	Workspace cannot be closed with by calling this.
	///	You need to close the window of a workspace to close it.
	@objc @IBAction
	func performClose(AnyObject?) {
		
	}
	
	

	///	Build and run default project current workspace. 
	///	By default, this runs `cargo` on workspace root.
	///	Customisation will be provided later.
	@objc @IBAction
	func run(AnyObject?) {
		self.runWorkspace()
	}
}


