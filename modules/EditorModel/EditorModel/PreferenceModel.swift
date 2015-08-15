//
//  PreferenceModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

///	Manages app-global preference.
///
public class PreferenceModel {

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
