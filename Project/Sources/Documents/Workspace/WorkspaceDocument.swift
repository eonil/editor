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
import EditorFileTreeNavigationFeature

///	A document to edit Eonil Editor Workspace. (`.eewsN` file, `N` is single integer version number)
///	The root controller of a workspace.
class WorkspaceDocument : NSDocument {
	let	mainWindowController		=	PlainFileFolderWindowController()
	
	override func makeWindowControllers() {
		//	Turning off the undo will effectively make autosave to be disabled.
		//	See "Not Supporting Undo" chapter.
		//	https://developer.apple.com/library/mac/documentation/DataManagement/Conceptual/DocBasedAppProgrammingGuideForOSX/StandardBehaviors/StandardBehaviors.html
		//
		//	This does not affect editing of each data-file.
		hasUndoManager	=	false
		
		super.makeWindowControllers()
		self.addWindowController(mainWindowController)
		
		assert(mainWindowController.fileTreeViewController.delegate == nil)
		mainWindowController.fileTreeViewController.delegate	=	self
	}
	

	
	
	
	private var rootURL:NSURL {
		get {
			return	mainWindowController.fileTreeViewController.URLRepresentation!		//	This cannot be `nil` if this document has been configured properly.
		}
	}
	
	private func runWorkspace() {
		CargoExecutionController.build(rootURL)
	}
}











extension WorkspaceDocument: FileTreeViewController4Delegate {
	func fileTreeViewController4IsNotifyingKillingRootURL() {
		self.performClose(self)
	}
	func fileTreeViewController4IsNotifyingUserWantsToEditFileAtURL(u: NSURL) {
		self.mainWindowController.codeEditingViewController.URLRepresentation	=	u
	}
}














///	MARK:
///	MARK:	Overriding default behaviors.

extension WorkspaceDocument {
	override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
		fatalError("Saving features all should be overridden to save current data file instead of workspace document. This method shouldn't be called.")
	}
	
	
	override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {		
		let	u2	=	self.fileURL!.URLByDeletingLastPathComponent
		mainWindowController.mainViewController.navigationViewController.fileTreeViewController.URLRepresentation	=	u2
		return	true
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
		self.close()
	}
	
	

	///	Build and run default project current workspace. 
	///	By default, this runs `cargo` on workspace root.
	///	Customisation will be provided later.
	@objc @IBAction
	func run(AnyObject?) {
		self.runWorkspace()
	}
}


