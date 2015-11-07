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

	private let	_mainMenuUI		=	MainMenuController()
	private let	_mainMenuManager	=	MainMenuAvailabilityManager()
	private var	_isRunning		=	false

	private func _installMenu() {
		_mainMenuManager.model			=	model!
		_mainMenuManager.mainMenuController	=	_mainMenuUI
		_mainMenuManager.isRunning		=	true
		_mainMenuUI.model			=	model!
		_mainMenuUI.isRunning			=	true
	}
	private func _deinstallMenu() {
		_mainMenuUI.isRunning			=	false
		_mainMenuUI.model			=	nil
		_mainMenuManager.isRunning		=	false
		_mainMenuManager.mainMenuController	=	nil
		_mainMenuManager.model			=	nil
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



























































