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

	public var model: Model {
		get {
			return	_model
		}
	}
	
	public func run() {
		_ui.model	=	_model
		_ui.run()
		_installAgents()

		//	TODO:	Remove this on release...
		//		ADHOC booting.
		_model.openWorkspaceAtURL(NSURL(string: "file:///~/Temp/TestWorkspace1")!)
	}

	public func halt() {
		_deinstallAgents()
		_ui.halt()
		_ui.model	=	nil
	}

	///

	private let	_ui			=	ApplicationUIController()
	private let	_model			=	Model()

	private let	_workspaceArrayAgent	=	_WorkspaceArrayAgent()

	///

	private func _installAgents() {
		_workspaceArrayAgent.owner	=	self
		_model.workspaces.register(_workspaceArrayAgent)
	}
	private func _deinstallAgents() {
		_model.workspaces.deregister(_workspaceArrayAgent)
		_workspaceArrayAgent.owner	=	nil
	}
	private func _insertWorkspace(workspace: WorkspaceModel) {
		let	doc	=	WorkspaceDocument()
		NSDocumentController.sharedDocumentController().addDocument(doc)

		let	wc	=	WorkspaceWindowUIController()
		wc.model	=	workspace
		doc.addWindowController(wc)
		wc.run()
	}
	private func _deleteWorkspace(workspace: WorkspaceModel) {
		let	result	=	_findUIForModel(workspace)
		if let result = result {
			result.windowController.halt()
			NSDocumentController.sharedDocumentController().removeDocument(result.document)
		}
		else {
			fatalError()
		}
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

























private final class _WorkspaceArrayAgent: ArrayStorageDelegate {
	weak var owner: Driver?
	private func willInsertRange(range: Range<Int>) {

	}
	private func didInsertRange(range: Range<Int>) {
		for ws in owner!._model.workspaces.array[range] {
			owner!._insertWorkspace(ws)
		}
	}
	private func willUpdateRange(range: Range<Int>) {

	}
	private func didUpdateRange(range: Range<Int>) {

	}
	private func willDeleteRange(range: Range<Int>) {

	}
	private func didDeleteRange(range: Range<Int>) {
		
	}
}

