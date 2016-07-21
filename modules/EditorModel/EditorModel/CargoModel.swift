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
final class CargoModel: ModelSubnode<WorkspaceModel>, BroadcastingModelType {

	typealias	State	=	CargoTool3.State

	enum Event: BroadcastableEventType {
		typealias	Sender	=	CargoModel
		case Subevent(CargoTool3.Event)
		case Reset
		case Output(String)
		case Error(String)
	}

	let	event	=	EventMulticast<Event>()




	///

	var workspace: WorkspaceModel {
		get {
			return	owner!
		}
	}


	var state: State {
		get {
			return	_cargoTool?.state ?? .Ready
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

	func runNewAtURL(u: NSURL, asExecutable: Bool) {
		assert(owner != nil)
		precondition(u.scheme == "file")
		precondition(u.path != nil)
		assert(_cargoTool == nil)
		_installCargoTool()
		_cargoTool!.runNew(path: u.URLByDeletingLastPathComponent!.path!, newDirectoryName: u.lastPathComponent!, asExecutable: asExecutable)
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

	/// Waits for current cargo operation to finish.
	/// This is no-op if there's no currently running
	/// cargo.
	func waitForCompletion() {
		_cargoTool!.waitForCompletion()
	}










	///

	private var	_cargoTool	:	CargoTool3?
	private let	_transition	=	Transition<State, Event>(.Ready, [
		(.Ready,	.Running,	.Subevent(.Launch)),
		(.Running,	.Cleaning,	.Subevent(.Clean)),
		(.Cleaning,	.Done,		.Subevent(.Exit)),
		(.Done,		.Ready,		.Reset),
		])




	///

	private func _installCargoTool() {
		assert(_cargoTool == nil)
		_cargoTool			=	CargoTool3()
		_cargoTool!.onEvent		=	{ [weak self] in self?._process($0) }
		_cargoTool!.onStandardOutput	=	{ [weak self] in self?._processOutput($0) }
		_cargoTool!.onStandardError	=	{ [weak self] in self?._processError($0) }
	}
	private func _deinstallCargoTool() {
		assert(_cargoTool != nil)
		_cargoTool!.onStandardError	=	nil
		_cargoTool!.onStandardOutput	=	nil
		_cargoTool!.onEvent		=	nil
		_cargoTool			=	nil
	}

	///

	private func _process(e: CargoTool3.Event) {
		switch e {
		case .Launch:
			break
		case .Clean:
			break
		case .Exit:
			_deinstallCargoTool()
		}
		Event.Subevent(e).dualcastAsNotificationWithSender(self)
	}
	private func _processOutput(s: String) {
		Event.Output(s).dualcastAsNotificationWithSender(self)
	}
	private func _processError(s: String) {
		Event.Error(s).dualcastAsNotificationWithSender(self)
	}
	private func _handleCargoCompletion() {
		_deinstallCargoTool()
		Event.Reset.dualcastAsNotificationWithSender(self)
	}

}


