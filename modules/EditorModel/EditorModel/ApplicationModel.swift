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

/// A model for application.
/// This manages whole application state, not only single document
/// or something else.
/// This exists for application, and designed toward to GUI.
///
/// **ALL** features of this object and subnodes must run in
/// main thread. Any non-main thread operations should be
/// performed with special care. Also, you must minimize performing
/// heavy load operations in main thread.
///
public class ApplicationModel: ModelRootNode {

	public override init() {
	}

	///

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		_preference.owner	=	self
	}
	override func willLeaveModelRoot() {
		_preference.owner	=	nil
		super.willLeaveModelRoot()
	}

	///

	/// Command-queue will be required eventually... but not right now.
	/// Prefer direct synchronous call to models rather then sending
	/// asynchronous command.
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

	/// Just creates workspace file structure, and does not open it.
	public func createWorkspaceAtURL(u: NSURL) {
		markUnimplemented()
	}

	/// You can supply any URL, and a workspace will be open only if
	/// the URL is valid. If there's already open workspace for the URL,
	/// no new workspace will be created, and the workspace will be
	/// selected.
	public func openWorkspaceAtURL(u: NSURL) {
		Debug.log("will open a workspace at \(u), ws count = \(_workspaces.array.count)")

		for ws in workspaces.array {
			if ws.location.value == u {
				Debug.log("a workspace already exist for address \(u), adding cancelled, and will select it, ws count = \(_workspaces.array.count)")
				selectCurrentWorkspace(ws)
				return
			}
		}

		///


		let	ws	=	WorkspaceModel(rootLocationURL: u)
		ws.owner	=	self
		_workspaces.append(ws)
		Debug.log("did open by adding a workspace \(ws), ws count = \(_workspaces.array.count)")
	}
	public func closeWorkspace(ws: WorkspaceModel) {
		assert(_currentWorkspace.value !== ws, "You cannot close a workspace that is current workspace. Deselect first.")
		assert(_workspaces.contains(ws))
		Debug.log("will remove a workspace \(ws), ws count = \(_workspaces.array.count)")

		_workspaces.removeFirstMatchingObject(ws)
		ws.owner	=	nil

		Debug.log("did remove a workspace \(ws), ws count = \(_workspaces.array.count)")
	}

	public func selectCurrentWorkspace(ws: WorkspaceModel) {
		assert(_workspaces.contains(ws))
		assert(_currentWorkspace.value == nil)
		_currentWorkspace.value		=	ws
		Debug.log("did select a workspace \(_currentWorkspace.value!), ws count = \(_workspaces.array.count)")
	}

	/// Deselects current workspace. Current workspace will become `nil`.
	/// This is no-op if there was no current workspace.
	public func deselectCurrentWorkspace() {
		assert(_currentWorkspace.value != nil)
		assert(_workspaces.contains(_currentWorkspace.value!))
		Debug.log("will deselect a workspace \(_currentWorkspace.value!), ws count = \(_workspaces.array.count)")

		if let _ = _currentWorkspace.value {
			_currentWorkspace.value		=	nil
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













