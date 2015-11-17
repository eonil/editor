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
import EditorUICommon

public class ApplicationUIController: SessionProtocol {

	public init() {
		assert(_theInstance === nil)
		_theInstance	=	self
	}
	deinit {
		assert(_theInstance === self)
		_theInstance	=	nil
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
		_installModelObservers()
		NSNotificationCenter.defaultCenter().addUIObserver(self, ApplicationUIController._process, NSWindowDidBecomeMainNotification)
		NSNotificationCenter.defaultCenter().addUIObserver(self, ApplicationUIController._process, NSWindowDidResignMainNotification)
	}
	public func halt() {
		assert(model != nil)
		NSNotificationCenter.defaultCenter().removeUIObserver(self, NSWindowDidResignMainNotification)
		NSNotificationCenter.defaultCenter().removeUIObserver(self, NSWindowDidBecomeMainNotification)
		_deinstallModelObservers()
		_deinstallMenu()
	}











	///

	internal static var theApplicationUIController: ApplicationUIController? {
		get {
			return	_theInstance
		}
	}

	internal func workspaceDocumentForModel(workspace: WorkspaceModel) -> WorkspaceDocument {
		return	_modelToViewMapping[identityOf(workspace)]!
	}








	///

	private let	_mainMenuUI		=	MainMenuController()
	private let	_mainMenuManager	=	MainMenuAvailabilityManager()
	private var	_isRunning		=	false
	private var	_modelToViewMapping	=	Dictionary<ReferentialIdentity<WorkspaceModel>, WorkspaceDocument>()


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






	private func _process(n: NSNotification) {
		switch n.name {
		case NSWindowDidBecomeMainNotification:
//			assertAndReportFailure(model!.currentWorkspace !== nil, "model!.currentWorkspace = \(model!.currentWorkspace)")
//			UIState.ForApplicationModel.Notification(model!, .Invalidate).broadcast()
			break

		case NSWindowDidResignMainNotification:
//			assertAndReportFailure(model!.currentWorkspace === nil)
//			UIState.ForApplicationModel.Notification(model!, .Invalidate).broadcast()
			break

		default:
			fatalError()
		}
	}
	

	private func _process(n: ApplicationModel.Event.Notification) {
		switch n.event {
		case .DidInitiate:
			break

		case .WillTerminate:
			break

		case .DidBeginCurrentWorkspace(_):
			break
			
		case .WillEndCurrentWorkspace(_):
			break

		case .DidAddWorkspace(let workspace): do {
			assert(workspace.location != nil)
			let	doc	=	WorkspaceDocument()
			_modelToViewMapping[identityOf(workspace)]	=	doc
			doc.workspaceWindowUIController.model		=	workspace
			NSDocumentController.sharedDocumentController().addDocument(doc)
			NSDocumentController.sharedDocumentController().noteNewRecentDocument(doc)
			NSDocumentController.sharedDocumentController().noteNewRecentDocumentURL(workspace.location!)
			doc.workspaceWindowUIController.run()
			}

		case .WillRemoveWorkspace(let workspace): do {
			let	doc	=	_modelToViewMapping[identityOf(workspace)]!
			doc.workspaceWindowUIController.halt()
			NSDocumentController.sharedDocumentController().removeDocument(doc)
			doc.workspaceWindowUIController.model		=	nil
			_modelToViewMapping[identityOf(workspace)]	=	nil
			}
		}


	}


}






















// Only one instance is allowed at once.
private weak var	_theInstance	:	ApplicationUIController?










































