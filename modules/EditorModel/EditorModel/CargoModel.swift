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
/// This serializes access to cargo tool to prevent acceidental conflict.
///
class CargoModel: ModelSubnode<WorkspaceModel> {

	typealias	Event	=	CargoTool2.Event






	///

	var workspace: WorkspaceModel {
		get {
			return	owner!
		}
	}









	///

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

	var state: CargoTool2.State? {
		get {
			return	_cargoTool?.state
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
	func runCleanAtURL(u: NSURL) {
		assert(owner != nil)
		precondition(u.scheme == "file")
		precondition(u.path != nil)
		assert(_cargoTool == nil)
		_installCargoTool()
		_cargoTool!.runClean(path: u.path!)
	}
	func stop() {
		assert(owner != nil)
		assert(_cargoTool != nil)
		if _cargoTool!.state == .Running {
			_cargoTool!.stop()
		}
		_deinstallCargoTool()
	}











	///

	private var	_cargoTool	:	CargoTool2?




	///

	private func _installCargoTool() {
		assert(_cargoTool == nil)
		_cargoTool		=	CargoTool2()
		_cargoTool!.onEvent	=	{ [weak self] in self?._process($0) }
	}
	private func _deinstallCargoTool() {
		assert(_cargoTool != nil)
		_cargoTool!.onEvent	=	nil
		_cargoTool		=	nil
	}

	///

	private func _process(e: CargoTool2.Event) {
		switch e {
		case .DidChangeState:
			_applyCargoToolState()
			
		case .DidComplete:
			_handleCargoCompletion()

		case .DidEmitOutputLogLine(_):
			break

		case .DidEmitErrorLogLine(_):
			break
		}

		Notification(self,e).broadcast()
	}
	private func _applyCargoToolState() {
		assert(_cargoTool != nil)
		switch _cargoTool!.state {
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
		_deinstallCargoTool()
	}

}


