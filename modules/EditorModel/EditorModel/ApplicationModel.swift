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
//		let	a	=	ToolLocationResolver.cargoToolLocation()
//		assert(a == "/Users/Eonil/Unix/homebrew/bin/cargo")
	}

	///

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		_preference.owner	=	self
//		_selection.owner	=	self
	}
	override func willLeaveModelRoot() {
//		_selection.owner	=	nil
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
	@available(*,deprecated=0,renamed="defaultWorkspace")
	public var currentWorkspace: ValueStorage<WorkspaceModel?> {
		get {
			return	_currentWorkspace
		}
	}
	public var defaultWorkspace: ValueStorage<WorkspaceModel?> {
		get {
			return	_currentWorkspace
		}
	}
//	public var selection: SelectionModel2 {
//		get {
//			return	_selection
//		}
//	}

	///

	/// Just opens a workspace, and create it at the place.
	///
	/// - Parameters:
	///	- location:	
	///		A URL to a file path that will become a workspace.
	///		This location will be created by `cargo` and must
	///		not exist at the point of calling.
	public func createAndOpenWorkspaceAtURL(location: NSURL) {
		let	ws	=	WorkspaceModel()
		ws.owner	=	self
		ws.locate(location)
		ws.tryCreating()
		_workspaces.append(ws)
		Debug.log("did create and add a workspace \(ws), ws count = \(_workspaces.array.count)")
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
				if let u1 = currentWorkspace.value?.location.value {
					if u1 != u {
						reselectCurrentWorkspace(ws)
//						deselectCurrentWorkspace()
//						selectCurrentWorkspace(ws)
					}
				}
				return
			}
		}

		///

		let	ws	=	WorkspaceModel()
		ws.locate(u)
		ws.owner	=	self
		_workspaces.append(ws)
		Debug.log("did open by adding a workspace \(ws), ws count = \(_workspaces.array.count)")
	}

	/// Closes a workspace.
	///
	/// - Parameters:
	///	- ws:
	///		Can be either of current or non-current workspace.
	///
	public func closeWorkspace(ws: WorkspaceModel) {
		assert(_workspaces.contains(ws))
		Debug.log("will remove a workspace \(ws), ws count = \(_workspaces.array.count)")

		_workspaces.removeFirstMatchingObject(ws)
		ws.owner	=	nil

		Debug.log("did remove a workspace \(ws), ws count = \(_workspaces.array.count)")
	}

//	public func selectCurrentWorkspace(ws: WorkspaceModel) {
//		assert(_workspaces.contains(ws))
//		assert(_currentWorkspace.value == nil)
//		_currentWorkspace.value		=	ws
//		Debug.log("did select a workspace \(_currentWorkspace.value!), ws count = \(_workspaces.array.count)")
//	}
//
//	/// Deselects current workspace. Current workspace will become `nil`.
//	/// This is no-op if there was no current workspace.
//	public func deselectCurrentWorkspace() {
//		assert(_currentWorkspace.value != nil)
//		assert(_workspaces.contains(_currentWorkspace.value!))
//		Debug.log("will deselect a workspace \(_currentWorkspace.value!), ws count = \(_workspaces.array.count)")
//
//		if let _ = _currentWorkspace.value {
//			_currentWorkspace.value		=	nil
//		}
//	}
	/// Selects another workspace.
	/// 
	/// Current workspace cannot be nil if there's any open workspace.
	/// This limitation is set by Cocoa AppKit because any next window
	/// will be selected automatically.
	public func reselectCurrentWorkspace(ws: WorkspaceModel) {
		if _currentWorkspace.value !== ws {
			_currentWorkspace.value	=	ws
		}
	}

	///
	
	private let	_preference		=	PreferenceModel()
	private let	_workspaces		=	MutableArrayStorage<WorkspaceModel>([])
	private let	_currentWorkspace	=	MutableValueStorage<WorkspaceModel?>(nil)
//	private let	_selection		=	SelectionModel2()

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













