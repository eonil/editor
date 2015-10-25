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

public class ApplicationUIController: SessionProtocol, ApplicationUIProtocol {

	public init() {

	}

	///
	
	public weak var model: ApplicationModel? {
		willSet {
			assert(_isRunning == false)
		}
	}

	///

//	public var currentWorkspaceUI: WorkspaceUIProtocol? {
//		get {
//			return	_currentWorkspaceUI.value
//		}
//	}
	public var currentWorkspaceUI2: ValueStorage2<WorkspaceUIProtocol?> {
		get {
			return	_currentWorkspaceUI
		}
	}
	
	public func run() {
		assert(model != nil)


		_installAgents()
		_installMenu()
//		_installAgents()
		_installCocoaNotificationHandlers()
	}
	public func halt() {
		assert(model != nil)

		_deinstallCocoaNotificaitonHandlers()
//		_deinstallAgents()
		_deinstallMenu()
		_deinstallAgents()
	}

	///

	private let	_menuUI			=	MainMenuController()
	private var	_isRunning		=	false
	private let	_currentWorkspaceUI	=	MutableValueStorage2<WorkspaceUIProtocol?>(nil)

	private func _installMenu() {
		//	I believe the application-menu can be replaced.
		//	But it doesn't. Anyway this is beta SDK, and
		//	I will retry again with final release...

		for menu in _menuUI.topLevelMenus {
			let	item	=	NSMenuItem(title: "", action: nil, keyEquivalent: "")
			item.submenu	=	menu
			NSApplication.sharedApplication().mainMenu!.addItem(item)
		}

		_menuUI.applicationUI	=	self
		_menuUI.model		=	model!
		_menuUI.run()
	}
	private func _deinstallMenu() {
		_menuUI.halt()
		_menuUI.model		=	nil
		_menuUI.applicationUI	=	nil

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

//	private func _installAgents() {
//		model!.currentWorkspace.registerDidSet(ObjectIdentifier(self)) { [weak self] in
//			if let curWS = self!.model!.currentWorkspace.value {
//				if let ui = self!._findUIForModel(curWS) {
//					ui.showWindow(self)
//				}
//				else {
//					fatalError("A UI for the workspace must be exists, but it was not.")
//				}
//			}
//			else {
//				//	No current workspace. Nothing to do.
//			}
//		}
//	}
//	private func _deinstallAgents() {
//		model!.currentWorkspace.deregisterDidSet(ObjectIdentifier(self))
//	}

//	private func _findUIForModel(workspace: WorkspaceModel) -> WorkspaceWindowUIController? {
//		for doc in NSDocumentController.sharedDocumentController().documents {
//			for wc in doc.windowControllers {
//				if let wc = wc as? WorkspaceWindowUIController {
//					if wc.model === workspace {
//						return	wc
//					}
//				}
//			}
//		}
//		return	nil
//	}







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

			self!._currentWorkspaceUI.value	=	workspaceUI
			Event.DidBeginCurrentWorkspaceUI.broadcastWithSender(self!)
		}
		NSNotificationCenter.defaultCenter().addUIObserver(ObjectIdentifier(self), forNotificationName: NSWindowDidResignMainNotification) { [weak self] (n: NSNotification) -> () in
			guard let window = n.object as? NSWindow else {
				fatalError("Cannot find the window object which resigned main.")
			}
			guard self != nil else {
				return
			}
			guard let workspaceUI = window.windowController as? WorkspaceWindowUIController else {
				return
			}

			assert(self!._currentWorkspaceUI.value === workspaceUI)
			Event.WillEndCurrentWorkspaceUI.broadcastWithSender(self!)
			self!._currentWorkspaceUI.value	=	nil
		}
	}
	private func _deinstallCocoaNotificaitonHandlers() {
		NSNotificationCenter.defaultCenter().removeUIObserver(ObjectIdentifier(self), forNotificationName: NSWindowDidResignMainNotification)
		NSNotificationCenter.defaultCenter().removeUIObserver(ObjectIdentifier(self), forNotificationName: NSWindowDidBecomeMainNotification)
	}















	///

	private let	_workspaceArrayAgent	=	_WorkspaceArrayAgent()
	private var	_workspaceModelToUIMap	=	[ObjectIdentifier: WorkspaceWindowUIController]()		//<	ObjectIdentifier(WorkspaceModel) -> WorkspaceWindowUIController
	private var	_workspaceModelToDocMap	=	[ObjectIdentifier: WorkspaceDocument]()				//<	ObjectIdentifier(WorkspaceModel) -> WorkspaceDocument

	///

	private func _installAgents() {
		_workspaceArrayAgent.owner	=	self
		model!.workspaces.register(_workspaceArrayAgent)
	}
	private func _deinstallAgents() {
		model!.workspaces.deregister(_workspaceArrayAgent)
		_workspaceArrayAgent.owner	=	nil
	}
	private func _insertWorkspaceUIForWorkspace(workspace: WorkspaceModel) {
		let	doc	=	WorkspaceDocument()
		NSDocumentController.sharedDocumentController().addDocument(doc)
		NSDocumentController.sharedDocumentController().noteNewRecentDocument(doc)
		NSDocumentController.sharedDocumentController().noteNewRecentDocumentURL(workspace.location.value!)

		let	wc	=	WorkspaceWindowUIController()
		wc.model	=	workspace
		doc.addWindowController(wc)

		_workspaceModelToUIMap[ObjectIdentifier(workspace)]	=	wc

		wc.run()
	}
	private func _deleteWorkspaceUIForWorkspace(workspace: WorkspaceModel) {
		assert(_workspaceModelToUIMap[ObjectIdentifier(workspace)] != nil)
		if let wsUI = _workspaceModelToUIMap[ObjectIdentifier(workspace)] {
			wsUI.halt()
			assert(wsUI.document is WorkspaceDocument)
			NSDocumentController.sharedDocumentController().removeDocument(wsUI.document! as! WorkspaceDocument)
		}
	}

	//	private func _findUIForModel(workspace: WorkspaceModel) -> (document: WorkspaceDocument, windowController: WorkspaceWindowUIController)? {
	//		for doc in NSDocumentController.sharedDocumentController().documents {
	//			if let doc = doc as? WorkspaceDocument {
	//				for wc in doc.windowControllers {
	//					if let wc = wc as? WorkspaceWindowUIController {
	//						return	(doc, wc)
	//					}
	//				}
	//			}
	//		}
	//		return	nil
	//	}
}















































private final class _WorkspaceArrayAgent: ArrayStorageDelegate {
	weak var owner: ApplicationUIController?
	private func willInsertRange(range: Range<Int>) {

	}
	private func didInsertRange(range: Range<Int>) {
		for ws in owner!.model!.workspaces.array[range] {
			owner!._insertWorkspaceUIForWorkspace(ws)
		}
	}
	private func willUpdateRange(range: Range<Int>) {

	}
	private func didUpdateRange(range: Range<Int>) {

	}
	private func willDeleteRange(range: Range<Int>) {
		for ws in owner!.model!.workspaces.array[range] {
			owner!._deleteWorkspaceUIForWorkspace(ws)
		}
	}
	private func didDeleteRange(range: Range<Int>) {

	}
}
















