//
//  Model.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

///	A model for application.
///	This exists for application, and designed toward to GUI.
///
public class Model {
	public var selection: Selection {
		get {
			return	_selection
		}
	}
	public var workspaces: ArrayStorage<WorkspaceModel> {
		get {
			return	_workspaces
		}
	}

	///
	
	private let	_selection	=	Selection()

	private let	_workspaces	=	MutableArrayStorage<WorkspaceModel>([])
}






