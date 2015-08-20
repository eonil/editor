//
//  LLDBModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/20.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import LLDBWrapper

class LLDBModel: ModelSubnode<WorkspaceModel> {

	var workspace: WorkspaceModel {
		get {
			return	owner!
		}
	}

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
	}
	override func willLeaveModelRoot() {
		deleteAllTargets()
		super.willLeaveModelRoot()
	}

	///

	/// Currently, supports only 64-bit target.
	func createTarget(filename: String) {
		let	m	=	LLDBTargetModel()
		m._core		=	_core.createTargetWithFilename(filename, andArchname: LLDBArchDefault64Bit)
		m.owner		=	self
		_targets.insert([m], atIndex: _targets.array.endIndex)
	}
	func deleteTarget(target: LLDBTargetModel) {
		if let idx = _targets.array.indexOfValueByReferentialIdentity(target) {
			let	t	=	_targets.array[idx]
			t.owner		=	nil
			_core.deleteTarget(t._core!)
			_targets.delete(idx..<idx)
		}
		else {
			fatalError()
		}
	}
	func deleteAllTargets() {
		for t in _targets.array {
			t.owner		=	nil
			_core.deleteTarget(t._core!)
		}
		_targets.delete(_targets.array.wholeRange)
	}
	
	///

	private let	_core		=	LLDBDebugger()
	private let	_targets	=	MutableArrayStorage<LLDBTargetModel>([])

	private func _indexOfTargetModelForTargetCore(targetCore: LLDBTarget) -> Int {
		for i in _targets.array.wholeRange {
			let	m	=	_targets.array[i]
			if m._core == targetCore {
				return	i
			}
		}
		fatalError()
	}
}




class LLDBTargetModel: ModelSubnode<LLDBModel> {

	var LLDB: LLDBModel {
		get {
			return	owner!
		}
	}

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
	}
	override func willLeaveModelRoot() {
		super.willLeaveModelRoot()
	}

	///

	private let	_location	=	MutableValueStorage<NSURL?>(nil)
	private var	_core		:	LLDBTarget?

	private func _install() {
		assert(owner != nil)
		assert(_core == nil)

	}
	private func _deinstall() {
		assert(owner != nil)
		assert(_core != nil)
		owner!._core.deleteTarget(_core!)
	}
}


















