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

	///
	
	private let	_preference	=	PreferenceModel()
	private let	_workspaces	=	MutableArrayStorage<WorkspaceModel>([])
	
}









