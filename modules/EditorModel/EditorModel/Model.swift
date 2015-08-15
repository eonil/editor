//
//  Model.swift
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
public class Model {

	public init() {
	}

	///

	public let commandQueue = CommandQueue()
	
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

	public func openWorkspaceAtURL(u: NSURL) {
		let	ws	=	WorkspaceModel(rootLocationURL: u)
		ws.owner	=	self
		_workspaces.append(ws)
	}
	public func closeWorkspace(ws: WorkspaceModel) {
		_workspaces.removeFirstMatchingObject(ws)
		ws.owner	=	nil
	}
	public func selectCurrentWorkspace(ws: WorkspaceModel) {
		_currentWorkspace.value		=	ws
	}
	public func deselectCurrentWorkspace() {
		_currentWorkspace.value		=	nil
	}

	///
	
	private let	_preference		=	PreferenceModel()
	private let	_workspaces		=	MutableArrayStorage<WorkspaceModel>([])
	private let	_currentWorkspace	=	MutableValueStorage<WorkspaceModel?>(nil)
}









