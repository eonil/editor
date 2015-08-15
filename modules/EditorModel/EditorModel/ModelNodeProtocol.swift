//
//  ModelNodeProtocol.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation



public class ModelRootNode: ModelNode {

	internal override init() {
		super.init()
	}

	///

	public func run() {
		_propagateJoining()
	}
	public func halt() {
		_propagateLeaving()
	}
	
}



public class ModelSubnode<T: ModelNode>: ModelNode {

	internal override init() {
		super.init()
	}
	deinit {
		assert(_hasOwner == false, "You must unset (assigning `nil`) `owner` explicitly before this object dies.")
	}

	///

	internal weak var owner: T? {
		willSet {
			if owner != nil {
				owner!._deregisterSubnode(self)
				_hasOwner	=	false
			}
		}
		didSet {
			if owner != nil {
				_hasOwner	=	true
				owner!._registerSubnode(self)
			}
		}
	}

	///

	private var	_hasOwner	=	false
}



public class ModelNode: ModelNodeSessionProtocol {

	private init() {
	}
	deinit {
		assert(_isJoined == false)
	}

	///

	internal var isRooted: Bool {
		get {
			return	_isJoined
		}
	}
	internal func didJoinModelTree() {
	}
	internal func willLeaveModelTree() {
	}

	///

	private var	_isJoined		=	false
	private var	_subnodes		=	[ModelNode]()
	private var	_registrationLock	=	false

	private func _registerSubnode(subnode: ModelNode) {
//		assert(_registrationLock == false, "You cannot register/deregister while installation/deinstallation events are propagating.")
		assert(subnode._isJoined == false)
		_subnodes.append(subnode)
		if _isJoined {
			subnode._propagateJoining()
		}
	}
	private func _deregisterSubnode(subnode: ModelNode) {
//		assert(_registrationLock == false, "You cannot register/deregister while installation/deinstallation events are propagating.")
		assert(subnode._isJoined == _isJoined)
		if _isJoined {
			subnode._propagateLeaving()
		}
		_subnodes	=	Array(_subnodes.filter({ $0 !== subnode }))
	}

	private func _propagateJoining() {
		_isJoined		=	true
		_registrationLock	=	true
		for subnode in _subnodes {
			subnode._propagateJoining()
		}
		didJoinModelTree()
		_registrationLock	=	false
	}
	private func _propagateLeaving() {
		_registrationLock	=	true
		willLeaveModelTree()
		for subnode in _subnodes {
			subnode._propagateLeaving()
		}
		_isJoined		=	false
		_registrationLock	=	false
	}
}

//internal protocol ModelNodeProtocol {
//	typealias	Owner: AnyObject
//
//	weak var owner: Owner? { get set }
//
//	func run()
//	func halt()
//}

internal protocol ModelNodeSessionProtocol: class {
	func didJoinModelTree()
	func willLeaveModelTree()
}