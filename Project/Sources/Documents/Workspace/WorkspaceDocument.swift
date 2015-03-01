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
	
	override init() {
		super.init()
		
		internals	=	InternalController(owner: self)
		
	}
	
	var projectMenuController:MenuController {
		get {
			return	internals!.projectMenuController
		}
	}
	var debugMenuController:MenuController {
		get {
			return	internals!.debuggingController.menuController
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
		self.addWindowController(internals!.mainWindowController)
		
		assert(internals!.mainWindowController.fileNavigationViewController.delegate != nil)
	}

	////
	
	private var	internals	=	nil as InternalController? {
		willSet {
			assert(internals == nil, "You can set this only once.")
		}
	}
	
	private var	_rootLocation			=	nil as FileLocation?
	
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
		assert(internals!.mainWindowController.fileNavigationViewController.delegate != nil)
		
		let	u2	=	self.fileURL!.URLByDeletingLastPathComponent!
		
		_rootLocation	=	FileLocation(u2)
		internals!.mainWindowController.fileNavigationViewController.URLRepresentation	=	u2
		
		let	p1	=	u2.path!
//		fileSystemMonitor	=	FileSystemEventMonitor(pathsToWatch: [p1]) { [weak self] events in
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
	func reconfigureForWorkspaceInternals(internals:InternalController) {
		build.reaction	=	{ [unowned self, unowned internals] in
			internals.buildWorkspace()
		}
		run.reaction	=	{ [unowned self, unowned internals] in
			internals.runWorkspace()
		}
		clean.reaction	=	{ [unowned self, unowned internals] in
			internals.cleanWorkspace()
		}
		stop.reaction	=	{ [unowned self, unowned internals] in
			internals.stopWorkspace()
		}

		reconfigureAvailabilitiesForWorkspaceInternals(internals)
	}
	func reconfigureAvailabilitiesForWorkspaceInternals(internals:InternalController) {
		build.enabled	=	internals.debuggingController.numberOfSessions == 0
		run.enabled		=	internals.debuggingController.numberOfSessions == 0
		clean.enabled	=	internals.debuggingController.numberOfSessions == 0
		stop.enabled	=	internals.debuggingController.numberOfSessions > 0
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

		internals!.mainWindowController.codeEditingViewController.trySavingInPlace()
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
///	MARK:	InternalController

///	Hardly-coupled internal subcomponent controller.
private final class InternalController {
	unowned let		owner					:	WorkspaceDocument
	
	let				mainWindowController	=	WorkspaceMainWindowController()
	let				debuggingController		=	WorkspaceDebuggingController()
	let				commandQueue			=	WorkspaceCommandExecutionController()
	let				projectMenuController	=	ProjectMenuController()
	
	private var		fileSystemMonitor		=	nil as FileSystemEventMonitor?
	
	init(owner: WorkspaceDocument) {
		self.owner	=	owner
		
		assert(mainWindowController.fileNavigationViewController.delegate == nil)
		mainWindowController.fileNavigationViewController.delegate			=	self
		mainWindowController.issueReportingViewController.delegate			=	self
		mainWindowController.executionNavigationViewController.delegate		=	self
		
		debuggingController.executionTreeViewController					=	self.mainWindowController.executionNavigationViewController
		debuggingController.variableTreeViewController						=	self.mainWindowController.variableInspectingViewController
		debuggingController.delegate										=	self
		
		projectMenuController.reconfigureForWorkspaceInternals(self)
	}
	deinit {
	}
}

extension InternalController {
	func buildWorkspace() {
		mainWindowController.issueReportingViewController.reset()
		
		commandQueue.cancelAllCommandExecution()
		commandQueue.queue(CargoCommand(
			workspaceRootURL: owner.rootLocation.stringExpression,
			subcommand: CargoCommand.Subcommand.Build,
			cargoDelegate: self))
		commandQueue.runAllCommandExecution()
	}
	
	///	Build and run default project current workspace.
	///	By default, this runs `cargo` on workspace root.
	///	Customisation will be provided later.
	func runWorkspace() {
		mainWindowController.issueReportingViewController.reset()
		
		commandQueue.cancelAllCommandExecution()
		commandQueue.queue(CargoCommand(
			workspaceRootURL: owner.rootLocation.stringExpression,
			subcommand: CargoCommand.Subcommand.Build,
			cargoDelegate: self))
		commandQueue.queue(LaunchDebuggingSessionCommand(
			debuggingController: debuggingController,
			workspaceRootURL: owner.rootLocation.stringExpression))
		commandQueue.runAllCommandExecution()
	}
	func cleanWorkspace() {
		mainWindowController.issueReportingViewController.reset()
		
		commandQueue.cancelAllCommandExecution()
		commandQueue.queue(CargoCommand(
			workspaceRootURL: owner.rootLocation.stringExpression,
			subcommand: CargoCommand.Subcommand.Clean,
			cargoDelegate: self))
		commandQueue.runAllCommandExecution()
	}
	func stopWorkspace() {
		debuggingController.terminateAllSessions()
		commandQueue.cancelAllCommandExecution()
		
		mainWindowController.executionNavigationViewController.snapshot		=	nil
		mainWindowController.variableInspectingViewController.snapshot		=	nil
	}
}








///	MARK:
///	MARK:	WorkspaceNavigationViewControllerDelegate
extension InternalController: WorkspaceNavigationViewControllerDelegate {
	func workpaceNavigationViewControllerWantsToOpenFileAtURL(u: NSURL) {
		mainWindowController.codeEditingViewController.URLRepresentation	=	u
	}
}























///	MARK:
///	MARK:	ExecutionStateTreeViewControllerDelegate

extension InternalController: ExecutionStateTreeViewControllerDelegate {
	private func executionStateTreeViewControllerDidSelectFrame(frame: LLDBFrame?) {
		mainWindowController.variableInspectingViewController.snapshot	=	VariableTreeViewController.Snapshot(frame)
	}
}



///	MARK:
///	MARK:	IssueListingViewControllerDelegate

extension InternalController: IssueListingViewControllerDelegate {
	func issueListingViewControllerUserWantsToHighlightURL(file: NSURL?) {
		Debug.assertMainThread()
		
	}
	func issueListingViewControllerUserWantsToHighlightIssue(issue: Issue) {
		Debug.assertMainThread()
		
		if let o = issue.origin {
			mainWindowController.codeEditingViewController.URLRepresentation	=	o.URL
			mainWindowController.codeEditingViewController.codeTextViewController.codeTextView.navigateToCodeRange(o.range)
		}
	}
}



///	MARK:
///	MARK:	WorkspaceDebuggingControllerDelegate

extension InternalController: WorkspaceDebuggingControllerDelegate {
	func workspaceDebuggingControllerDidLaunchSession() {
		projectMenuController.reconfigureAvailabilitiesForWorkspaceInternals(self)
	}
	func workspaceDebuggingControllerDidTerminateSession() {
		projectMenuController.reconfigureAvailabilitiesForWorkspaceInternals(self)
	}
}




///	MARK:
///	MARK:	CargoExecutionControllerDelegate

extension InternalController: CargoExecutionControllerDelegate {
	func cargoExecutionControllerDidDiscoverRustCompilationIssue(issue: RustCompilerIssue) {
		Debug.assertMainThread()
		
//		let	s	=	Issue(workspaceRootURL: owner.rootLocation.stringExpression, rust: issue)
		let	s	=	Issue(rust: issue)
		mainWindowController.issueReportingViewController.push([s])
	}
	func cargoExecutionControllerDidPrintMessage(s: String) {
		Debug.assertMainThread()

		println(s)
	}
	func cargoExecutionControllerRemoteProcessDidTerminate() {
		
	}
}











































































//extension InternalController: FileTreeViewController4Delegate {
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


