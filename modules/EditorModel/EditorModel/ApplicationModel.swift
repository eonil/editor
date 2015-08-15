//
//  ApplicationModel.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon

///	A model for application.
///	This manages whole application state, not only single document
///	or something else.
///	This exists for application, and designed toward to GUI.
///
///	**ALL** features of this object and subnodes must run in
///	main thread. Any non-main thread operations should be
///	performed with special care. Also, you must minimize performing
///	heavy load operations in main thread.
///
public class ApplicationModel: ModelRootNode {

	public override init() {
	}

	///

	override func didJoinModelTree() {
		super.didJoinModelTree()
		_preference.owner	=	self
	}
	override func willLeaveModelTree() {
		_preference.owner	=	nil
		super.willLeaveModelTree()
	}

	///

	///	Command-queue will be required eventually... but not right now.
	///	Prefer direct synchronous call to models rather then sending
	///	asynchronous command.
//	public let commandQueue = CommandQueue()

	public var preference: PreferenceModel {
		get {
			return	_preference
		}
	}
	public var workspaces: ArrayStorage<WorkspaceModel> {
		get {
			return	_workspaces
		}
	}
	public var currentWorkspace: ValueStorage<WorkspaceModel?> {
		get {
			return	_currentWorkspace
		}
	}

	///

	///	Just creates workspace file structure, and does not open it.
	public func createWorkspaceAtURL(u: NSURL) {
		markUnimplemented()
	}

	///	You can supply any URL, and a workspace will be open only if
	///	the URL is valid. If there's already open workspace for the URL,
	///	no new workspace will be created, and the workspace will be
	///	selected.
	public func openWorkspaceAtURL(u: NSURL) {
		for ws in workspaces.array {
			print(ws.location.value)
			if ws.location.value == u {
				selectCurrentWorkspace(ws)
				return
			}
		}

		///

		let	ws	=	WorkspaceModel(rootLocationURL: u)
		ws.owner	=	self
		_workspaces.append(ws)
	}
	public func closeWorkspace(ws: WorkspaceModel) {
		assert(_currentWorkspace.value !== ws, "You cannot close a workspace that is current workspace. Deselect first.")
		_workspaces.removeFirstMatchingObject(ws)
		ws.owner	=	nil
	}
	public func selectCurrentWorkspace(ws: WorkspaceModel) {
		if _currentWorkspace.value !== ws {
			_currentWorkspace.value		=	ws
			print("selected a workspace at = \(ws.location.value!)")
		}
	}

	///	Closes current workspace. A next workspace will be selected 
	///	automatically if exists. 
	///	This is no-op if there was no current workspace.
	public func deselectCurrentWorkspace() {
		if let curWS = _currentWorkspace.value {
			assert(_indexOfWorkspace(curWS) != nil, "The workspace must still be contained in workspace list.")
			if let newWS = _priorWorkspaceOfWorkspace(curWS) ?? _nextWorkspaceOfWorkspace(curWS) {
				_currentWorkspace.value		=	newWS
			}
			else {
				_currentWorkspace.value		=	nil
			}
		}
	}

	///
	
	private let	_preference		=	PreferenceModel()
	private let	_workspaces		=	MutableArrayStorage<WorkspaceModel>([])
	private let	_currentWorkspace	=	MutableValueStorage<WorkspaceModel?>(nil)

	private func _nextWorkspaceOfWorkspace(workspace: WorkspaceModel) -> WorkspaceModel? {
		if let idx = _indexOfWorkspace(workspace) {
			if idx < (_workspaces.array.count - 1) {
				return	_workspaces.array[idx+1]
			}
		}
		return	nil
	}
	private func _priorWorkspaceOfWorkspace(workspace: WorkspaceModel) -> WorkspaceModel? {
		if let idx = _indexOfWorkspace(workspace) {
			if idx > 0 {
				return	_workspaces.array[idx-1]
			}
		}
		return	nil
	}
	public func _indexOfWorkspace(workspace: WorkspaceModel) -> Int? {
		for i in 0..<_workspaces.array.count {
			let	ws	=	_workspaces.array[i]
			if ws === workspace {
				return	i
			}
		}
		return	0
	}
}









