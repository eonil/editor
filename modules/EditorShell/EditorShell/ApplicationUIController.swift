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

	public var currentWorkspaceUI: WorkspaceUIProtocol? {
		get {
			return	NSApplication.sharedApplication().mainWindow?.windowController as? WorkspaceWindowUIController
		}
	}
	
	public func run() {
		assert(model != nil)


		_installMenu()
		_installAgents()
		_installNotificationHandlers()
	}
	public func halt() {
		assert(model != nil)

		_deinstallNotificaitonHandlers()
		_deinstallAgents()
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

	private func _installAgents() {
		model!.currentWorkspace.registerDidSet(ObjectIdentifier(self)) { [weak self] in
			if let curWS = self!.model!.currentWorkspace.value {
				if let ui = self!._findUIForModel(curWS) {
					ui.showWindow(self)
				}
				else {
					fatalError("A UI for the workspace must be exists, but it was not.")
				}
			}
			else {
				//	No current workspace. Nothing to do.
			}
		}
	}
	private func _deinstallAgents() {
		model!.currentWorkspace.deregisterDidSet(ObjectIdentifier(self))
	}

	private func _findUIForModel(workspace: WorkspaceModel) -> WorkspaceWindowUIController? {
		for doc in NSDocumentController.sharedDocumentController().documents {
			for wc in doc.windowControllers {
				if let wc = wc as? WorkspaceWindowUIController {
					if wc.model === workspace {
						return	wc
					}
				}
			}
		}
		return	nil
	}





	private func _installNotificationHandlers() {
//		NSNotificationCenter.defaultCenter().addUIObserver(ObjectIdentifier(self), forNotificationName: NSWindowDidBecomeMainNotification) { [weak self] (n: NSNotification) -> () in
//			guard let _ = n.object as? NSWindow else {
//				fatalError("Cannot find the window object which became main.")
//			}
//			guard self != nil else {
//				return
//			}
//			Event.DidChangeCurrentWorkspace.broadcastWithSender(self!)
//		}
//		NSNotificationCenter.defaultCenter().addUIObserver(ObjectIdentifier(self), forNotificationName: NSWindowDidResignMainNotification) { [weak self] (n: NSNotification) -> () in
//			guard let _ = n.object as? NSWindow else {
//				fatalError("Cannot find the window object which resigned main.")
//			}
//			guard self != nil else {
//				return
//			}
//			Event.DidChangeCurrentWorkspace.broadcastWithSender(self!)
//		}
	}
	private func _deinstallNotificaitonHandlers() {
//		NSNotificationCenter.defaultCenter().removeUIObserver(ObjectIdentifier(self), forNotificationName: NSWindowDidResignMainNotification)
//		NSNotificationCenter.defaultCenter().removeUIObserver(ObjectIdentifier(self), forNotificationName: NSWindowDidBecomeMainNotification)
	}
}














