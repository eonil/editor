//
//  Driver.swift
//  EditorDriver
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import MulticastingStorage
import EditorModel
import EditorShell


public class Driver {

	public static var theDriver: Driver {
		get {
			assert(_currentDriver != nil, "Current driver has not yet been set.")
			return	_currentDriver!
		}
	}
	private static var	_currentDriver: Driver?

	///

	public init() {
		assert(Driver._currentDriver == nil)
		Driver._currentDriver	=	self
	}
	deinit {
		assert(Driver._currentDriver === self)
		Driver._currentDriver	=	nil
	}

	///

	public var model: ApplicationModel {
		get {
			return	_model
		}
	}
	
	public func run() {

		_ui.model	=	_model
		_ui.run()
		_model.run()

		_installAgents()

		//	TODO:	Remove this on release...
		//		ADHOC booting.
		_model.openWorkspaceAtURL(NSURL(string: "file:///~/Temp/TestWorkspace1")!)
	}

	public func halt() {
		_deinstallAgents()

		_model.halt()
		_ui.halt()
		_ui.model	=	nil

	}

	///

	private let	_ui			=	ApplicationUIController()
	private let	_model			=	ApplicationModel()

	private let	_workspaceArrayAgent	=	_WorkspaceArrayAgent()
	private var	_workspaceModelToUIMap	=	[ObjectIdentifier: WorkspaceWindowUIController]()		//<	ObjectIdentifier(WorkspaceModel) -> WorkspaceWindowUIController
	private var	_workspaceModelToDocMap	=	[ObjectIdentifier: WorkspaceDocument]()				//<	ObjectIdentifier(WorkspaceModel) -> WorkspaceDocument

	///

	private func _installAgents() {
		_workspaceArrayAgent.owner	=	self
		_model.workspaces.register(_workspaceArrayAgent)
	}
	private func _deinstallAgents() {
		_model.workspaces.deregister(_workspaceArrayAgent)
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
	weak var owner: Driver?
	private func willInsertRange(range: Range<Int>) {

	}
	private func didInsertRange(range: Range<Int>) {
		for ws in owner!._model.workspaces.array[range] {
			owner!._insertWorkspaceUIForWorkspace(ws)
		}
	}
	private func willUpdateRange(range: Range<Int>) {

	}
	private func didUpdateRange(range: Range<Int>) {

	}
	private func willDeleteRange(range: Range<Int>) {
		for ws in owner!._model.workspaces.array[range] {
			owner!._deleteWorkspaceUIForWorkspace(ws)
		}
	}
	private func didDeleteRange(range: Range<Int>) {
		
	}
}









