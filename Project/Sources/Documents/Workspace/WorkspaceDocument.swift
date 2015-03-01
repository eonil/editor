//
//  WorkspaceDocument.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import LLDBWrapper
import EonilFileSystemEvents
import EditorCommon
import EditorUIComponents
import EditorToolComponents
import EditorWorkspaceNavigationFeature
import EditorIssueListingFeature
import EditorDebuggingFeature

///	A document to edit Eonil Editor Workspace. (`.eewsN` file, `N` is single integer version number)
///
///	Manages interaction with Cocoa document system.
final class WorkspaceDocument: NSDocument {
	let	mainWindowController	=	WorkspaceMainWindowController()
	
	override init() {
		super.init()
		
		_subcomponentController.owner	=	self
		
		assert(mainWindowController.fileNavigationViewController.delegate == nil)
		mainWindowController.fileNavigationViewController.delegate			=	_subcomponentController
		mainWindowController.issueReportingViewController.delegate			=	_subcomponentController
		mainWindowController.executionNavigationViewController.delegate		=	_subcomponentController
		
		_debuggingController.executionTreeViewController					=	mainWindowController.executionNavigationViewController
		_debuggingController.variableTreeViewController						=	mainWindowController.variableInspectingViewController
		_debuggingController.delegate										=	_subcomponentController
		
		_projectMenuController.reconfigureForWorkspaceDocument(self)
	}
	
	var projectMenuController:MenuController {
		get {
			return	_projectMenuController
		}
	}
	var debugMenuController:MenuController {
		get {
			return	_debuggingController.menuController
		}
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
		
		assert(mainWindowController.fileNavigationViewController.delegate != nil)
	}

	////
	
	private var	_rootLocation			=	nil as FileLocation?
	private var	_fileSystemMonitor		=	nil as FileSystemEventMonitor?
	private let	_subcomponentController	=	SubcomponentController()
	private let	_debuggingController	=	WorkspaceDebuggingController()
	private let	_commandQueue			=	WorkspaceCommandExecutionController()
	private let _projectMenuController	=	ProjectMenuController()
	
	private var rootLocation:FileLocation {
		get {
			return	_rootLocation!			//	This cannot be `nil` if this document has been configured properly.
		}
	}
	
}




































///	MARK:
///	MARK:	Overriding default behaviors.

extension WorkspaceDocument {	
	
	override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
		fatalError("Saving features all should be overridden to save current data file instead of workspace document. This method shouldn't be called.")
	}
	
	
	override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		assert(mainWindowController.fileNavigationViewController.delegate != nil)
		
		let	u2	=	self.fileURL!.URLByDeletingLastPathComponent!
		
		_rootLocation	=	FileLocation(u2)
		mainWindowController.fileNavigationViewController.URLRepresentation	=	u2
		
		let	p1	=	u2.path!
//		_fileSystemMonitor	=	FileSystemEventMonitor(pathsToWatch: [p1]) { [weak self] events in
//			for ev in events {
//				self?.postprocessFileSystemEventAtURL(ev)
//			}
//			//					sm.routeEvent(u1)
//		}
		return	true
	}
	
//	private func postprocessFileSystemEventAtURL(event:FileSystemEvent) {
//		let	isDir		=	(event.flag & EonilFileSystemEventFlag.ItemIsDir) == EonilFileSystemEventFlag.ItemIsDir
//		let	u1			=	NSURL(fileURLWithPath: event.path, isDirectory: isDir)!
//		
//		if u1 == rootLocation.stringExpression {
//			if u1.existingAsDirectoryFile == false || u1.fileReferenceURL()! != rootLocation.fileSystemNode {
//				//	Root location has been deleted.
//				self.performClose(self)
//				return
//			}
//		}
//		
//		////
//		
//		Debug.log(event.flag)
//		enum Operation {
//			init(flag:FileSystemEventFlag) {
//				let	isDelete	=	(flag & EonilFileSystemEventFlag.ItemRemoved) == EonilFileSystemEventFlag.ItemRemoved
//				if isDelete {
//					self	=	Delete
//					return
//				}
//				let	isCreate	=	(flag & EonilFileSystemEventFlag.ItemCreated) == EonilFileSystemEventFlag.ItemCreated
//				if isCreate {
//					self	=	Create
//					return
//				}
//				let	isMove	=	(flag & EonilFileSystemEventFlag.ItemRenamed) == EonilFileSystemEventFlag.ItemRenamed
//				if isMove {
//					self	=	Move
//					return
//				}
//				let	isModified	=	(flag & EonilFileSystemEventFlag.ItemModified) == EonilFileSystemEventFlag.ItemModified
//				if isModified {
//					self	=	Modify
//					return
//				}
//				
////				fatalError("Unknown file system event flag.")
//				self	=	None
//			}
//			case None
//			case Create
//			case Move
//			case Modify
//			case Delete
//		}
//
//		switch Operation(flag: event.flag) {
//		case .None:
//			Debug.log("NONE: \(u1)")
//			
//		case .Create:
//			Debug.log("CREATE: \(u1)")
//			
//		case .Move:
//			Debug.log("MOVE: \(u1)")
//			if u1 == mainWindowController.codeEditingViewController.URLRepresentation {
//				self.postprocessDisappearingOfFileAtURL(u1)
//			}
//			
//		case .Delete:
//			Debug.log("DELETE: \(u1)")
//			if u1 == mainWindowController.codeEditingViewController.URLRepresentation {
//				self.postprocessDisappearingOfFileAtURL(u1)
//			}
//			
//		case .Modify:
//			Debug.log("MODIFY: \(u1)")
//		}
//		
//		mainWindowController.fileNavigationViewController.invalidateNodeForURL(u1)
//	}
//	private func postprocessDisappearingOfFileAtURL(u:NSURL) {
//		if u == mainWindowController.codeEditingViewController.URLRepresentation {
//			mainWindowController.codeEditingViewController.URLRepresentation	=	nil
//		}
//	}
}
























///	MARK:
///	MARK:	Dynamic Menu

private extension ProjectMenuController {
	func reconfigureForWorkspaceDocument(owner:WorkspaceDocument) {
		build.reaction	=	{ [unowned self, unowned owner] in
			owner.buildWorkspace()
		}
		run.reaction	=	{ [unowned self, unowned owner] in
			owner.runWorkspace()
		}
		clean.reaction	=	{ [unowned self, unowned owner] in
			owner.cleanWorkspace()
		}
		stop.reaction	=	{ [unowned self, unowned owner] in
			owner.stopWorkspace()
		}

		reconfigureAvailabilitiesForOwner(owner)
	}
	func reconfigureAvailabilitiesForOwner(owner:WorkspaceDocument) {
		build.enabled	=	owner._debuggingController.numberOfSessions == 0
		run.enabled		=	owner._debuggingController.numberOfSessions == 0
		clean.enabled	=	owner._debuggingController.numberOfSessions == 0
		stop.enabled	=	owner._debuggingController.numberOfSessions > 0
	}
}

private extension WorkspaceDocument {
	func buildWorkspace() {
		mainWindowController.issueReportingViewController.reset()
		
		_commandQueue.cancelAllCommandExecution()
		_commandQueue.queue(CargoCommand(
			workspaceRootURL: rootLocation.stringExpression,
			subcommand: CargoCommand.Subcommand.Build,
			cargoDelegate: _subcomponentController))
		_commandQueue.runAllCommandExecution()
	}
	
	///	Build and run default project current workspace.
	///	By default, this runs `cargo` on workspace root.
	///	Customisation will be provided later.
	func runWorkspace() {
		mainWindowController.issueReportingViewController.reset()
		
		_commandQueue.cancelAllCommandExecution()
		_commandQueue.queue(CargoCommand(
			workspaceRootURL: rootLocation.stringExpression,
			subcommand: CargoCommand.Subcommand.Build,
			cargoDelegate: _subcomponentController))
		_commandQueue.queue(LaunchDebuggingSessionCommand(
			debuggingController: _debuggingController,
			workspaceRootURL: rootLocation.stringExpression))
		_commandQueue.runAllCommandExecution()
	}
	func cleanWorkspace() {
		mainWindowController.issueReportingViewController.reset()
		
		_commandQueue.cancelAllCommandExecution()
		_commandQueue.queue(CargoCommand(
			workspaceRootURL: rootLocation.stringExpression,
			subcommand: CargoCommand.Subcommand.Clean,
			cargoDelegate: _subcomponentController))
		_commandQueue.runAllCommandExecution()
	}
	func stopWorkspace() {
		_debuggingController.terminateAllSessions()
		_commandQueue.cancelAllCommandExecution()
		
		mainWindowController.executionNavigationViewController.snapshot		=	nil
		mainWindowController.variableInspectingViewController.snapshot		=	nil
	}
}

///	MARK:
///	MARK:	Static menu handling via First Responder chain

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

}









































































///	MARK:
///	MARK:	SubcomponentController

///	Hardly-coupled internal subcomponent controller.
private final class SubcomponentController {
	weak var owner:WorkspaceDocument! {
		willSet {
			assert(self.owner == nil, "`owner` can be set only once.")
		}
	}
}

///	MARK:
///	MARK:	WorkspaceNavigationViewControllerDelegate
extension SubcomponentController: WorkspaceNavigationViewControllerDelegate {
	func workpaceNavigationViewControllerWantsToOpenFileAtURL(_: NSURL) {
		
	}
}

//extension SubcomponentController: FileTreeViewController4Delegate {
//	func fileTreeViewController4QueryFileSystemSubnodeURLsOfURL(u: NSURL) -> [NSURL] {
//		Debug.assertMainThread()
//		
//		return	subnodeAbsoluteURLsOfURL(u)
//	}
//	
//	func fileTreeViewController4UserWantsToCreateFolderInURL(parentFolderURL: NSURL) -> Resolution<NSURL> {
//		Debug.assertMainThread()
//		
//		return	FileUtility.createNewFolderInFolder(parentFolderURL)
//	}
//	func fileTreeViewController4UserWantsToCreateFileInURL(parentFolderURL: NSURL) -> Resolution<NSURL> {
//		Debug.assertMainThread()
//		
//		return	FileUtility.createNewFileInFolder(parentFolderURL)
//	}
//	func fileTreeViewController4UserWantsToRenameFileAtURL(from: NSURL, to: NSURL) -> Resolution<()> {
//		Debug.assertMainThread()
//		
//		return	fileTreeViewController4UserWantsToMoveFileAtURL(from, to: to)
//	}
//	func fileTreeViewController4UserWantsToMoveFileAtURL(from: NSURL, to: NSURL) -> Resolution<()> {
//		Debug.assertMainThread()
//		
//		var	err	=	nil as NSError?
//		let	ok	=	NSFileManager.defaultManager().moveItemAtURL(from, toURL: to, error: &err)
//		assert(ok || err != nil)
//		if ok {
//			owner.mainWindowController.codeEditingViewController.URLRepresentation	=	to
//		}
//		return	ok ? Resolution.success() : Resolution.failure(err!)
//	}
//	func fileTreeViewController4UserWantsToDeleteFilesAtURLs(us: [NSURL]) -> Resolution<()> {
//		Debug.assertMainThread()
//		
//		//	Just always close the currently editing file.
//		//	Deletion may fail, and then user may see closed document without deletion,
//		//	but it doesn't seem to be bad. So this is an intended design.
//		owner.mainWindowController.codeEditingViewController.URLRepresentation	=	nil
//		
//		var	err	=	nil as NSError?
//		for u in us {
//			let	ok	=	NSFileManager.defaultManager().trashItemAtURL(u, resultingItemURL: nil, error: &err)
//			assert(ok || err != nil)
//			if !ok {
//				return	Resolution.failure(err!)
//			}
//		}
//		return	Resolution.success()
//	}
//	
//	func fileTreeViewController4UserWantsToEditFileAtURL(u: NSURL) -> Bool {
//		Debug.assertMainThread()
//		
//		owner.mainWindowController.codeEditingViewController.URLRepresentation	=	u
//		return	true
//	}
//}
//
//private func subnodeAbsoluteURLsOfURL(absoluteURL:NSURL) -> [NSURL] {
//	var	us1	=	[] as [NSURL]
//	if NSFileManager.defaultManager().fileExistsAtPathAsDirectoryFile(absoluteURL.path!) {
//		let	u1	=	absoluteURL
//		let	it1	=	NSFileManager.defaultManager().enumeratorAtURL(u1, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles | NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, errorHandler: { (url:NSURL!, error:NSError!) -> Bool in
//			fatalError("Unhandled file I/O error!")	//	TODO:
//			return	false
//		})
//		let	it2	=	it1!
//		while let o1 = it2.nextObject() as? NSURL {
//			us1.append(o1)
//		}
//	}
//	return	us1
//}






















///	MARK:
///	MARK:	ExecutionStateTreeViewControllerDelegate

extension SubcomponentController: ExecutionStateTreeViewControllerDelegate {
	private func executionStateTreeViewControllerDidSelectFrame(frame: LLDBFrame?) {
		owner!.mainWindowController.variableInspectingViewController.snapshot	=	VariableTreeViewController.Snapshot(frame)
	}
}



///	MARK:
///	MARK:	IssueListingViewControllerDelegate

extension SubcomponentController: IssueListingViewControllerDelegate {
	func issueListingViewControllerUserWantsToHighlightURL(file: NSURL?) {
		Debug.assertMainThread()
		
	}
	func issueListingViewControllerUserWantsToHighlightIssue(issue: Issue) {
		Debug.assertMainThread()
		
		if let o = issue.origin {
			owner.mainWindowController.codeEditingViewController.URLRepresentation	=	o.URL
			owner.mainWindowController.codeEditingViewController.codeTextViewController.codeTextView.navigateToCodeRange(o.range)
		}
	}
}



///	MARK:
///	MARK:	WorkspaceDebuggingControllerDelegate

extension SubcomponentController: WorkspaceDebuggingControllerDelegate {
	func workspaceDebuggingControllerDidLaunchSession() {
//		func aa(a:()->()) {
//			
//		}
//		aa()
//		{
//			
//		}
		owner._projectMenuController.reconfigureAvailabilitiesForOwner(owner)
	}
	func workspaceDebuggingControllerDidTerminateSession() {
		owner._projectMenuController.reconfigureAvailabilitiesForOwner(owner)
	}
}




///	MARK:
///	MARK:	CargoExecutionControllerDelegate

extension SubcomponentController: CargoExecutionControllerDelegate {
	func cargoExecutionControllerDidDiscoverRustCompilationIssue(issue: RustCompilerIssue) {
		Debug.assertMainThread()
		
//		let	s	=	Issue(workspaceRootURL: owner.rootLocation.stringExpression, rust: issue)
		let	s	=	Issue(rust: issue)
		owner.mainWindowController.issueReportingViewController.push([s])
	}
	func cargoExecutionControllerDidPrintMessage(s: String) {
		Debug.assertMainThread()

		println(s)
	}
	func cargoExecutionControllerRemoteProcessDidTerminate() {
		
	}
}
























































