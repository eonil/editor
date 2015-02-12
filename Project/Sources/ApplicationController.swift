//
//  ApplicationController.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Cocoa
import EditorCommon

@NSApplicationMain
class ApplicationController: NSObject, NSApplicationDelegate {
}













///	MARK:
///	MARK:	Application Lifecycle Management
extension ApplicationController {
	func applicationDidFinishLaunching(aNotification: NSNotification) {
	}
	
	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
}













///	MARK:
///	MARK:	Document Handling
extension ApplicationController {
	func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
		return	false
	}
}














///	MARK:
///	MARK:	Global Menu Handlers

///	"Open" always opens an existing workspace. There's no concept of opening a data file.
///	"Save" family menus save currently editing data file.
///
extension ApplicationController {
	
	///	Creates a new workspace.
	///	User will be asked to select a directory to store new workspace.
	@objc @IBAction
	func newDocument(AnyObject?) {
		let	p		=	NSSavePanel()
		p.beginWithCompletionHandler { (r:Int) -> Void in
			switch r {
			case NSFileHandlingPanelOKButton:
				if let u = p.URL {
					let	workspaceDirFileURL		=	u
					if workspaceDirFileURL.existingAsAnyFile {
						//	If a URL to an existing file item, that means user confirmed overwriting of the whole directory tree.
						//	Anyway, move them to the system Trash instead of deleting it for safety.
						//	Operation may fail, regardless of file existence when we check before due to asynchronous nature of file system.
						//	Just try and check returning error to handle bad situations.
						var	trashingError		=	nil as NSError?
						NSFileManager.defaultManager().trashItemAtURL(workspaceDirFileURL, resultingItemURL: nil, error: &trashingError)
						
						if let e = trashingError {
							NSApplication.sharedApplication().presentError(e)
							//						UIDialogues.alertModally("Couldn't move the existing workspace to Trash.", comment: "There was an error while trashing it.", style: NSAlertStyle.WarningAlertStyle)
							return
						}
					}
					
					////
					
					if let workspaceConfigFileURL = WorkspaceUtility.createNewWorkspaceAtURL(workspaceDirFileURL) {
						//	Try opening newrly created project as a document.
						//	Ignore failure.
						NSDocumentController.sharedDocumentController().openDocumentWithContentsOfURL(workspaceConfigFileURL, display: true, completionHandler: { (document:NSDocument!, documentWasAlreadyOpen:Bool, error:NSError!) -> Void in
							//	Nothing to do.
						})
					} else {
						UIDialogues.alertModally("Could not create a project with the name.", comment: nil, style: NSAlertStyle.InformationalAlertStyle)
					}
				} else {
					//	Unknown situation. Ignore it.
				}
				
			case NSFileHandlingPanelCancelButton:
				//	Ignore cancellation.
				break
				
			default:
				fatalError()
			}
		}
	}
	
	@objc @IBAction
	func newDataFile(AnyObject?) {
		
	}
	
}
























