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

	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		_installCargoTool()
	}
	override func willLeaveModelRoot() {
		if _cargoTool != nil {
			stop()
		}
		super.willLeaveModelRoot()
	}

	func runNewAtURL(u: NSURL) {
		precondition(u.scheme == "file")
		precondition(u.path != nil)
		assert(_cargoTool == nil)
		_installCargoTool()
		_cargoTool!.runNew(path: u.URLByDeletingLastPathComponent!.path!, newDirectoryName: u.lastPathComponent!)
	}
	func stop() {
		assert(_cargoTool != nil)
		_cargoTool!.stop()
		_deinstallCargoTool()
	}

	///

	private let	_state		=	MutableValueStorage<CargoTool.State>(.Idle)
	private var	_cargoTool	:	CargoTool?

	private func _installCargoTool() {
		_cargoTool	=	CargoTool()
		_cargoTool!.state.registerDidSet(ObjectIdentifier(self)) { [weak self] in self!._applyCargoToolState() }
	}
	private func _deinstallCargoTool() {
		_cargoTool!.state.deregisterDidSet(ObjectIdentifier(self))
		_cargoTool	=	nil
	}

	private func _applyCargoToolState() {
		assert(_cargoTool != nil)
		if _state.value != _cargoTool!.state.value {
			_state.value	=	_cargoTool!.state.value
		}

		switch _cargoTool!.state.value {
		case .Idle:
			break
		case .Running:
			break
		case .Done:
			dispatchToMainQueueAsynchronously { [weak self] in
				assert(self != nil)
				if self!._cargoTool != nil {
					self!._deinstallCargoTool()
				}
			}
		case .Error:
			dispatchToMainQueueAsynchronously { [weak self] in
				assert(self != nil)
				if self!._cargoTool != nil {
					self!._deinstallCargoTool()
				}
			}
		}
	}
}

