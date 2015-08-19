//
//  CargoModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/16.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon

/// Multiple-time re-usable cargo tool.
///
class CargoModel: ModelSubnode<WorkspaceModel> {

	var workspace: WorkspaceModel {
		get {
			return	owner!
		}
	}

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		assert(_cargoTool == nil)
	}
	override func willLeaveModelRoot() {
		if _cargoTool != nil {
			stop()
		}
		super.willLeaveModelRoot()
	}

	var isRunning: Bool {
		get {
			return	_cargoTool != nil
		}
	}

	var state: ValueStorage<CargoTool.State?> {
		get {
			return	_state
		}
	}

	func runNewAtURL(u: NSURL) {
		assert(owner != nil)
		precondition(u.scheme == "file")
		precondition(u.path != nil)
		assert(_cargoTool == nil)
		_installCargoTool()
		_cargoTool!.runNew(path: u.URLByDeletingLastPathComponent!.path!, newDirectoryName: u.lastPathComponent!)
	}
	func runBuildAtURL(u: NSURL) {
		assert(owner != nil)
		precondition(u.scheme == "file")
		precondition(u.path != nil)
		assert(_cargoTool == nil)
		_installCargoTool()
		_cargoTool!.runBuild(path: u.path!)
	}
	func stop() {
		assert(owner != nil)
		assert(_cargoTool != nil)
		if _cargoTool!.state.value == .Running {
			_cargoTool!.stop()
		}
		_deinstallCargoTool()
	}

	///

	private let	_state		=	MutableValueStorage<CargoTool.State?>(nil)
	private var	_cargoTool	:	CargoTool?

	private let	_cargoOutputA	=	_OutputLogAgent()

	///

	private func _installCargoTool() {
		assert(_cargoTool == nil)
		_cargoTool		=	CargoTool()
		_cargoTool!.completion.queue() { [weak self] in self!._handleCargoCompletion() }
		_cargoTool!.state.registerDidSet(ObjectIdentifier(self)) { [weak self] in self!._applyCargoToolState() }

		_handleCargoOutputLinesDidInsertInRange(_cargoTool!.outputLog.array.wholeRange)
		_cargoOutputA.owner	=	self
		_cargoTool!.outputLog.register(_cargoOutputA)
	}
	private func _deinstallCargoTool() {
		assert(_cargoTool != nil)

		_cargoTool!.outputLog.deregister(_cargoOutputA)
		_cargoOutputA.owner	=	nil

		_cargoTool!.state.deregisterDidSet(ObjectIdentifier(self))
		_cargoTool		=	nil
	}

	///

	private func _applyCargoToolState() {
		assert(_cargoTool != nil)
		if _state.value != _cargoTool!.state.value {
			_state.value	=	_cargoTool!.state.value
		}

		switch _cargoTool!.state.value {
		case .Ready:
			break
		case .Running:
			break
		case .Done:
			break
		case .Error:
			break
		}
	}
	private func _handleCargoCompletion() {
		_state.value	=	nil
		_deinstallCargoTool()
	}

	private func _handleCargoOutputLinesDidInsertInRange(range: Range<Int>) {
		workspace.console.appendLines(_cargoTool!.outputLog.array[range])
	}
}






private final class _OutputLogAgent: ArrayStorageDelegate {
	weak var owner: CargoModel?
	private func willInsertRange(range: Range<Int>) {
	}
	private func didInsertRange(range: Range<Int>) {
		owner!._handleCargoOutputLinesDidInsertInRange(range)
	}
	private func willUpdateRange(range: Range<Int>) {
	}
	private func didUpdateRange(range: Range<Int>) {
	}
	private func willDeleteRange(range: Range<Int>) {
	}
	private func didDeleteRange(range: Range<Int>) {
	}
}



