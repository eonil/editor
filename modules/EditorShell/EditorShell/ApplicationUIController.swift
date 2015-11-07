//
//  ApplicationUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import MulticastingStorage
import EditorCommon
import EditorModel

public class ApplicationUIController: SessionProtocol {

	public init() {

	}

	///

	public weak var model: ApplicationModel? {
		willSet {
			assert(_isRunning == false)
		}
	}

	///
	
	public func run() {
		assert(model != nil)

		_installMenu()
		_installCocoaNotificationHandlers()
		_installModelObservers()
	}
	public func halt() {
		assert(model != nil)
		_deinstallModelObservers()
		_deinstallCocoaNotificaitonHandlers()
		_deinstallMenu()
	}












	///

	private let	_menuUI			=	MainMenuController()
	private var	_isRunning		=	false

	private func _installMenu() {
		//	I believe the application-menu can be replaced.
		//	But it doesn't. Anyway this is beta SDK, and
		//	I will retry again with final release...

		for menu in _menuUI.topLevelMenus {
			let	item	=	NSMenuItem(title: "", action: nil, keyEquivalent: "")
			item.submenu	=	menu
			NSApplication.sharedApplication().mainMenu!.addItem(item)
		}

		_menuUI.model		=	model!
		_menuUI.run()
	}
	private func _deinstallMenu() {
		_menuUI.halt()
		_menuUI.model		=	nil

		let	menus	=	Set(_menuUI.topLevelMenus)
		var	kills	=	[NSMenuItem]()
		for item in NSApplication.sharedApplication().mainMenu!.itemArray {
			if item.submenu != nil && menus.contains(item.submenu!) {
				kills.append(item)
			}
		}
		for item in kills {
			NSApplication.sharedApplication().mainMenu!.removeItem(item)
		}
	}

	private func _installModelObservers() {
		ApplicationModel.Event.Notification.register	(self, ApplicationUIController._process)
	}
	private func _deinstallModelObservers() {
		ApplicationModel.Event.Notification.deregister	(self)
	}

	private func _process(n: ApplicationModel.Event.Notification) {
		switch n.event {
		case .DidInitiate:
			break
		case .WillTerminate:
			break
		case .DidBeginCurrentWorkspace(let workspace):
			_findUIForModel(workspace)!.windowController.window!.makeMainWindow()

		case .WillEndCurrentWorkspace(_):
			break

		case .DidAddWorkspace(let workspace):
			_insertWorkspaceUIForWorkspace(workspace)
			break

		case .WillRemoveWorkspace(let workspace):
			_deleteWorkspaceUIForWorkspace(workspace)
			break
		}
	}




	private func _installCocoaNotificationHandlers() {
		NSNotificationCenter.defaultCenter().addUIObserver(ObjectIdentifier(self), forNotificationName: NSWindowDidBecomeMainNotification) { [weak self] (n: NSNotification) -> () in
			guard let window = n.object as? NSWindow else {
				fatalError("Cannot find the window object which became main.")
			}
			guard self != nil else {
				return
			}
			guard let workspaceUI = window.windowController as? WorkspaceWindowUIController else {
				return
			}

			self!.model!.currentWorkspace	=	workspaceUI.model!
		}
		NSNotificationCenter.defaultCenter().addUIObserver(ObjectIdentifier(self), forNotificationName: NSWindowDidResignMainNotification) { [weak self] (n: NSNotification) -> () in
			guard let window = n.object as? NSWindow else {
				fatalError("Cannot find the window object which resigned main.")
			}
			guard self != nil else {
				return
			}
			guard let ui = window.windowController as? WorkspaceWindowUIController else {
				return
			}

			self!.model!.currentWorkspace	=	nil
		}
	}
	private func _deinstallCocoaNotificaitonHandlers() {
		NSNotificationCenter.defaultCenter().removeUIObserver(ObjectIdentifier(self), forNotificationName: NSWindowDidResignMainNotification)
		NSNotificationCenter.defaultCenter().removeUIObserver(ObjectIdentifier(self), forNotificationName: NSWindowDidBecomeMainNotification)
	}















	///




	///

	private func _insertWorkspaceUIForWorkspace(workspace: WorkspaceModel) {
		let	doc	=	WorkspaceDocument()
		NSDocumentController.sharedDocumentController().addDocument(doc)
		NSDocumentController.sharedDocumentController().noteNewRecentDocument(doc)
		NSDocumentController.sharedDocumentController().noteNewRecentDocumentURL(workspace.location!)

		let	wc	=	WorkspaceWindowUIController()
		wc.model	=	workspace
		doc.addWindowController(wc)

		wc.run()
	}
	private func _deleteWorkspaceUIForWorkspace(workspace: WorkspaceModel) {
		guard let (doc, uic) = _findUIForModel(workspace) else {
			fatalError("Cannot find UI objects for the workspace `\(workspace)`.")
		}
		uic.halt()
		NSDocumentController.sharedDocumentController().removeDocument(doc)
	}

	private func _findUIForModel(workspace: WorkspaceModel) -> (document: WorkspaceDocument, windowController: WorkspaceWindowUIController)? {
		for doc in NSDocumentController.sharedDocumentController().documents {
			if let doc = doc as? WorkspaceDocument {
				for wc in doc.windowControllers {
					if let wc = wc as? WorkspaceWindowUIController {
						return	(doc, wc)
					}
				}
			}
		}
		return	nil
	}
}



























































