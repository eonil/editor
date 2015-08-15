//
//  SearchModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public class SearchModel {
	internal weak var owner: WorkspaceModel?

	internal init() {
	}

	///

	public var workspace: WorkspaceModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}
}
