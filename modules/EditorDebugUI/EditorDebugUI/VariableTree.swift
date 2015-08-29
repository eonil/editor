//
//  VariableTree.swift
//  EditorDebugUI
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper

/// A virtual snapshot of variables for a frame. (this may contain out-of-frame variables)
///
/// Unlike `ContextTree`, this resolves subnodes lazily.
///
class VariableTree {
	func reconfigure(data: [LLDBValue]) {
		self.variables		=	newListWithReusingNodeForSameDataID(variables, newDataList: data, instantiate: _instantiateVariableNode)
	}

	///

	private(set) var	variables	=	[VariableNode]()
}

class VariableNode: DataNode {

	private(set) var	data		:	LLDBValue?

	var subvariables: [VariableNode] {
		get {
			if _isLoaded == false {
				_loadSubvariables()
			}
			return	_subvariables
		}
	}
	func reconfigure(data: LLDBValue?) {
		_reconfigure(data)
	}

	///

	private var	_subvariables	=	[VariableNode]()
	private var	_isLoaded	=	false

	///
	
	private func _reconfigure(data: LLDBValue?) {
		self.data		=	data
		if _isLoaded {
			_isLoaded	=	false
			_loadSubvariables()
		}
	}

	private func _loadSubvariables() {
		assert(_isLoaded == false)
		_subvariables		=	newListWithReusingNodeForSameDataID(_subvariables, newDataList: data?.allAvailableChildren ?? [], instantiate: _instantiateVariableNode)
		_isLoaded		=	true
	}
}













private func _instantiateVariableNode() -> VariableNode {
	return	VariableNode()
}

extension LLDBValue: LocallyIdentifiable {
	func getID() -> LLDBUserIDType {
		return	self.ID
	}
}





