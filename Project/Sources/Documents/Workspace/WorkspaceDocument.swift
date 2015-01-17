//
//  WorkspaceDocument.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import Precompilation
import PrecompilationOfExternalToolSupport
import EditorFileTreeNavigationFeature
import EonilFileSystemEvents

///	A document to edit Eonil Editor Workspace. (`.eewsN` file, `N` is single integer version number)
///	The root controller of a workspace.
class WorkspaceDocument : NSDocument {
	let	mainWindowController		=	PlainFileFolderWindowController()
	
	
	override init() {
		super.init()
		
		assert(mainWindowController.fileTreeViewController.delegate == nil)
		mainWindowController.fileTreeViewController.delegate	=	self
	}
	
	override func makeWindowControllers() {
		//	Turning off the undo will effectively make autosave to be disabled.
		//	See "Not Supporting Undo" chapter.
		//	https://developer.apple.com/library/mac/documentation/DataManagement/Conceptual/DocBasedAppProgrammingGuideForOSX/StandardBehaviors/StandardBehaviors.html
		//
		//	This does not affect editing of each data-file.
		hasUndoManager	=	false
		
		super.makeWindowControllers()
		self.addWindowController(mainWindowController)
		
		assert(mainWindowController.fileTreeViewController.delegate != nil)
	}
	
	

	
	////
	
	private var	_rootLocation			=	nil as FileLocation?
	private var	_fileSystemMonitor		=	nil as FileSystemEventMonitor?
	
	private var rootLocation:FileLocation {
		get {
			return	_rootLocation!			//	This cannot be `nil` if this document has been configured properly.
		}
	}
	
	private func runWorkspace() {
		CargoExecutionController.build(rootLocation.stringExpression)
	}
}










extension WorkspaceDocument: FileTreeViewController4Delegate {
	func fileTreeViewController4QueryFileSystemSubnodeURLsOfURL(u: NSURL) -> [NSURL] {
		return	subnodeAbsoluteURLsOfURL(u)
	}
	
	func fileTreeViewController4UserWantsToCreateFolderInURL(parentFolderURL: NSURL) -> Resolution<NSURL> {
		return	FileUtility.createNewFolderInFolder(parentFolderURL)
	}
	func fileTreeViewController4UserWantsToCreateFileInURL(parentFolderURL: NSURL) -> Resolution<NSURL> {
		return	FileUtility.createNewFileInFolder(parentFolderURL)
	}
	func fileTreeViewController4UserWantsToRenameFileAtURL(from: NSURL, to: NSURL) -> Resolution<()> {
		return	fileTreeViewController4UserWantsToMoveFileAtURL(from, to: to)
	}
	func fileTreeViewController4UserWantsToMoveFileAtURL(from: NSURL, to: NSURL) -> Resolution<()> {
		var	err	=	nil as NSError?
		let	ok	=	NSFileManager.defaultManager().moveItemAtURL(from, toURL: to, error: &err)
		assert(ok || err != nil)
		if ok {
			self.mainWindowController.codeEditingViewController.URLRepresentation	=	to
		}
		return	ok ? Resolution.success() : Resolution.failure(err!)
	}
	func fileTreeViewController4UserWantsToDeleteFilesAtURLs(us: [NSURL]) -> Resolution<()> {
		//	Just always close the currently editing file.
		//	Deletion may fail, and then user may see closed document without deletion,
		//	but it doesn't seem to be bad. So this is an intended design.
		self.mainWindowController.codeEditingViewController.URLRepresentation	=	nil
		
		var	err	=	nil as NSError?
		for u in us {
			let	ok	=	NSFileManager.defaultManager().trashItemAtURL(u, resultingItemURL: nil, error: &err)
			assert(ok || err != nil)
			if !ok {
				return	Resolution.failure(err!)
			}
		}
		return	Resolution.success()
	}
	
	func fileTreeViewController4UserWantsToEditFileAtURL(u: NSURL) -> Bool {
		self.mainWindowController.codeEditingViewController.URLRepresentation	=	u
		return	true
	}
}

private func subnodeAbsoluteURLsOfURL(absoluteURL:NSURL) -> [NSURL] {
	var	us1	=	[] as [NSURL]
	if NSFileManager.defaultManager().fileExistsAtPathAsDirectoryFile(absoluteURL.path!) {
		let	u1	=	absoluteURL
		let	it1	=	NSFileManager.defaultManager().enumeratorAtURL(u1, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles | NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, errorHandler: { (url:NSURL!, error:NSError!) -> Bool in
			fatalError("Unhandled file I/O error!")	//	TODO:
			return	false
		})
		let	it2	=	it1!
		while let o1 = it2.nextObject() as? NSURL {
			us1.append(o1)
		}
	}
	return	us1
}



































///	MARK:
///	MARK:	Overriding default behaviors.

extension WorkspaceDocument {
	override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
		fatalError("Saving features all should be overridden to save current data file instead of workspace document. This method shouldn't be called.")
	}
	
	
	override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		assert(mainWindowController.fileTreeViewController.delegate != nil)
		
		let	u2	=	self.fileURL!.URLByDeletingLastPathComponent!
		
		_rootLocation	=	FileLocation(u2)
		mainWindowController.mainViewController.navigationViewController.fileTreeViewController.URLRepresentation	=	u2
		
		let	p1	=	u2.path!
		_fileSystemMonitor	=	FileSystemEventMonitor(pathsToWatch: [p1]) { [weak self] events in
			for ev in events {
				self?.postprocessFileSystemEventAtURL(ev)
			}
			//					sm.routeEvent(u1)
		}
		return	true
	}
	
	private func postprocessFileSystemEventAtURL(event:FileSystemEvent) {
		let	isDir		=	(event.flag & EonilFileSystemEventFlag.ItemIsDir) == EonilFileSystemEventFlag.ItemIsDir
		let	u1			=	NSURL(fileURLWithPath: event.path, isDirectory: isDir)!
		
		if u1 == rootLocation.stringExpression {
			if u1.existingAsDirectoryFile == false || u1.fileReferenceURL()! != rootLocation.fileSystemNode {
				//	Root location has been deleted.
				self.performClose(self)
				return
			}
		}
		
		////
		
		Debug.log(event.flag)
		enum Operation {
			init(flag:FileSystemEventFlag) {
				let	isDelete	=	(flag & EonilFileSystemEventFlag.ItemRemoved) == EonilFileSystemEventFlag.ItemRemoved
				if isDelete {
					self	=	Delete
					return
				}
				let	isCreate	=	(flag & EonilFileSystemEventFlag.ItemCreated) == EonilFileSystemEventFlag.ItemCreated
				if isCreate {
					self	=	Create
					return
				}
				let	isMove	=	(flag & EonilFileSystemEventFlag.ItemRenamed) == EonilFileSystemEventFlag.ItemRenamed
				if isMove {
					self	=	Move
					return
				}
				let	isModified	=	(flag & EonilFileSystemEventFlag.ItemModified) == EonilFileSystemEventFlag.ItemModified
				if isModified {
					self	=	Modify
					return
				}
				
				fatalError("Unknown file system event flag.")
//				self	=	None
			}
//			case None
			case Create
			case Move
			case Modify
			case Delete
		}

		switch Operation(flag: event.flag) {
		case .Create:
			Debug.log("CREATE: \(u1)")
			
		case .Move:
			Debug.log("MOVE: \(u1)")
			if u1 == mainWindowController.codeEditingViewController.URLRepresentation {
				self.postprocessDisappearingOfFileAtURL(u1)
			}
			
		case .Delete:
			Debug.log("DELETE: \(u1)")
			if u1 == mainWindowController.codeEditingViewController.URLRepresentation {
				self.postprocessDisappearingOfFileAtURL(u1)
			}
			
		case .Modify:
			Debug.log("MODIFY: \(u1)")
		}
		
		mainWindowController.mainViewController.navigationViewController.fileTreeViewController.invalidateNodeForURL(u1)
	}
	private func postprocessDisappearingOfFileAtURL(u:NSURL) {
		if u == mainWindowController.codeEditingViewController.URLRepresentation {
			mainWindowController.codeEditingViewController.URLRepresentation	=	nil
		}
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


