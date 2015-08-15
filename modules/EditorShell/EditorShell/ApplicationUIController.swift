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
		_installAgents()
	}
	public func halt() {
		assert(model != nil)

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

		_menuUI.model	=	model!
		_menuUI.run()
	}
	private func _deinstallMenu() {
		_menuUI.halt()
		_menuUI.model	=	nil

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
			if let ui = self!._findUIForModel(self!.model!.currentWorkspace.value!) {
				ui.showWindow(self)
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
}














