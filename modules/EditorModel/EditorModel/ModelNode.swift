//
//  ModelNode.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon


public class ModelRootNode: ModelNode {

	internal override init() {
		super.init()
	}
	deinit {
		assert(_isRunning == false, "You must `halt` this object before this object dies for proper clean-up.")
	}

	///

	public func run() {
		assert(_isRunning == false)
		_propagateJoining()
		_isRunning	=	true
	}
	public func halt() {
		assert(_isRunning == true)
		_propagateLeaving()
		_isRunning	=	false
	}

	///

	private var	_isRunning	=	false
}



public class ModelSubnode<T: ModelNode>: ModelNode {

	internal override init() {
		super.init()
	}
	deinit {
		assert(_hasOwner == false, "You must unset (assigning `nil`) `owner` explicitly for proper clean-up before this object dies.")
	}

	///

	internal weak var owner: T? {
		willSet {
			assert((owner == nil && newValue != nil) || (owner != nil && newValue == nil))
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
		assert(_isRooted == false)
	}

	///

	public internal(set) var version	=	StateVersion()

	///

	internal var isRooted: Bool {
		get {
			return	_isRooted
		}
	}
	internal func didJoinModelRoot() {
	}
	internal func willLeaveModelRoot() {
	}

//	internal func registerSubnode(subnode: ModelNode) {
//		_registerSubnode(subnode)
//	}
//	internal func deregisterSubnode(subnode: ModelNode) {
//		_deregisterSubnode(subnode)
//	}

	///

	private var	_isRooted		=	false
	private var	_subnodes		=	[ModelNode]()

	private func _registerSubnode(subnode: ModelNode) {
		assert(subnode._isRooted == false)
		_subnodes.append(subnode)
		if _isRooted {
			subnode._propagateJoining()
		}
	}
	private func _deregisterSubnode(subnode: ModelNode) {
		assert(subnode._isRooted == _isRooted)
		if _isRooted {
			subnode._propagateLeaving()
		}
		assert(_subnodes.containsValueByReferentialIdentity(subnode) == true)
		_subnodes.removeAtIndex(_subnodes.indexOfValueByReferentialIdentity(subnode)!)
		assert(_subnodes.containsValueByReferentialIdentity(subnode) == false)
	}

	private func _propagateJoining() {
		_isRooted		=	true
		for subnode in _subnodes {
			subnode._propagateJoining()
		}
		didJoinModelRoot()
	}
	private func _propagateLeaving() {
		willLeaveModelRoot()
		for subnode in _subnodes {
			subnode._propagateLeaving()
		}
		_isRooted		=	false
	}
}


internal protocol ModelNodeSessionProtocol: class {
	func didJoinModelRoot()
	func willLeaveModelRoot()
}













protocol ModelNdoeType {
	typealias	OwnerType: AnyObject
	weak var owner: OwnerType? { get set }
}


























